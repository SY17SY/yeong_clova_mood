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

export const onPostDeleted = functions.firestore.onDocumentDeleted(
  {
    document: "posts/{postId}",
    region: "asia-northeast3",
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      console.log("No data associated with the event");
      return;
    }

    try {
      const postData = snapshot.data();
      const postId = event.params.postId;
      console.log(`Processing deletion for post ${postId}`);

      const bucket = admin.storage().bucket();
      const deletePromises: Promise<void>[] = [];

      if (postData.thumbUrl && typeof postData.thumbUrl === "string") {
        deletePromises.push(
          (async () => {
            try {
              const urlParts = postData.thumbUrl.split("/o/");
              if (urlParts.length > 1) {
                const filePath = decodeURIComponent(urlParts[1].split("?")[0]);
                console.log(`Deleting thumb image: ${filePath}`);
                await bucket.file(filePath).delete();
                console.log(`Successfully deleted thumb image: ${filePath}`);
              }
            } catch (error) {
              console.error(`Failed to delete thumb image ${postData.thumbUrl}:`, error);
            }
          })()
        );
      }

      if (postData.imgUrls && Array.isArray(postData.imgUrls)) {
        const imgDeletePromises = postData.imgUrls.map(async (imageUrl: string) => {
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
    const [postId, uid] = event.params.clovaId.split("_");

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

    const [postId, uid] = event.params.clovaId.split("_");

    await db.collection("posts").doc(postId).collection("clovas").doc(uid).delete();
    await db
      .collection("posts")
      .doc(postId)
      .update({
        clovas: admin.firestore.FieldValue.increment(-1),
      });
    await db.collection("users").doc(uid).collection("clovas").doc(postId).delete();
  }
);
