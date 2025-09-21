/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import { setGlobalOptions } from "firebase-functions";
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";

// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

admin.initializeApp();

export const onPostCreated = functions.firestore.onDocumentCreated(
  {
    document: "posts/{postId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const data = snapshot.data();
    const postId = event.params.postId;

    try {
      await db.collection("users").doc(data.uid).collection("posts").doc(postId).set(data);
      console.log(`Post ${postId} replicated to user ${data.uid} collection`);
    } catch (e) {
      console.error("Error replicating post:", e);
    }
  }
);

export const onPostDeleted = functions.firestore.onDocumentDeleted(
  {
    document: "posts/{postId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const data = snapshot.data();
    const postId = event.params.postId;

    const bucket = admin.storage().bucket();
    const deletePromises: Promise<void>[] = [];

    try {
      if (data.thumbUrl && typeof data.thumbUrl === "string") {
        deletePromises.push(
          (async () => {
            try {
              const urlParts = data.thumbUrl.split("/o/");
              if (urlParts.length > 1) {
                const filePath = decodeURIComponent(urlParts[1].split("?")[0]);
                console.log(`Deleting thumb image: ${filePath}`);
                await bucket.file(filePath).delete();
                console.log(`Successfully deleted thumb image: ${filePath}`);
              }
            } catch (error) {
              console.error(`Failed to delete thumb image ${data.thumbUrl}:`, error);
            }
          })()
        );
      }

      if (data.imgUrls && Array.isArray(data.imgUrls)) {
        const imgDeletePromises = data.imgUrls.map(async (imageUrl: string) => {
          try {
            const urlParts = imageUrl.split("/o/");
            if (urlParts.length > 1) {
              const filePath = decodeURIComponent(urlParts[1].split("?")[0]);
              console.log(`Deleting image: ${filePath}`);
              await bucket.file(filePath).delete();
              console.log(`Successfully deleted image: ${filePath}`);
            }
          } catch (error) {
            console.error(`Failed to delete image ${imageUrl}:`, error);
          }
        });

        deletePromises.push(...imgDeletePromises);
      }

      await Promise.allSettled(deletePromises);
      console.log(`Completed image cleanup for post ${postId}`);
    } catch (error) {
      console.error("Error in onPostDeleted:", error);
    }

    try {
      await db.collection("users").doc(data.uid).collection("posts").doc(postId).delete();
    } catch (e) {
      console.error("Error in onPostDeleted in Users:", e);
    }
  }
);

export const onClovaCreated = functions.firestore.onDocumentCreated(
  {
    document: "clovas/{clovaId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const createdAt = snapshot.data().createdAt;
    const [postUid, postId, uid] = event.params.clovaId.split("_");

    try {
      await db.collection("posts").doc(postId).collection("clovas").doc(uid).set({
        createdAt: createdAt,
      });
      await db
        .collection("posts")
        .doc(postId)
        .update({
          clovas: admin.firestore.FieldValue.increment(1),
        });
      await db.collection("users").doc(uid).collection("clovas").doc(postId).set({
        createdAt: createdAt,
      });
      await db
        .collection("users")
        .doc(postUid)
        .collection("posts")
        .doc(postId)
        .update({
          clovas: admin.firestore.FieldValue.increment(1),
        });
    } catch (e) {
      console.error("Error in onClovaCreated:", e);
    }
  }
);

export const onClovaDeleted = functions.firestore.onDocumentDeleted(
  {
    document: "clovas/{clovaId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const [postUid, postId, uid] = event.params.clovaId.split("_");

    try {
      await db.collection("posts").doc(postId).collection("clovas").doc(uid).delete();
      await db
        .collection("posts")
        .doc(postId)
        .update({
          clovas: admin.firestore.FieldValue.increment(-1),
        });
      await db.collection("users").doc(uid).collection("clovas").doc(postId).delete();
      await db
        .collection("users")
        .doc(postUid)
        .collection("posts")
        .doc(postId)
        .update({
          clovas: admin.firestore.FieldValue.increment(-1),
        });
    } catch (e) {
      console.error("Error deleting clova:", e);
    }
  }
);

export const onCommentCreated = functions.firestore.onDocumentCreated(
  {
    document: "posts/{postId}/comments/{commentId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const data = snapshot.data();
    const postId = event.params.postId;
    const commentId = event.params.commentId;
    const [postUid, uid, _] = commentId.split("_"); // _: createdAt

    try {
      await db.collection("users").doc(uid).collection("comments").doc(commentId).set(data);
      await db
        .collection("posts")
        .doc(postId)
        .update({
          comments: admin.firestore.FieldValue.increment(1),
        });
      await db
        .collection("users")
        .doc(postUid)
        .collection("posts")
        .doc(postId)
        .update({
          comments: admin.firestore.FieldValue.increment(1),
        });
    } catch (e) {
      console.error("Error in onCommentCreated:", e);
    }
  }
);

export const onCommentDeleted = functions.firestore.onDocumentDeleted(
  {
    document: "posts/{postId}/comments/{commentId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const db = admin.firestore();
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    const postId = event.params.postId;
    const commentId = event.params.commentId;
    const [postUid, uid, _] = commentId.split("_"); // _: createdAt

    try {
      await db.collection("users").doc(uid).collection("comments").doc(commentId).delete();
      await db
        .collection("posts")
        .doc(postId)
        .update({
          comments: admin.firestore.FieldValue.increment(-1),
        });
      await db
        .collection("users")
        .doc(postUid)
        .collection("posts")
        .doc(postId)
        .update({
          comments: admin.firestore.FieldValue.increment(-1),
        });
    } catch (e) {
      console.error("Error in onCommentCreated:", e);
    }
  }
);
