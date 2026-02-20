const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

// Listen for new documents in the 'transactions' collection
exports.sendTransferNotification = functions.firestore
    .document("transactions/{transactionId}")
    .onCreate(async (snap, context) => {
      const transactionData = snap.data();

      // We only want to send notifications for success transfers
      if (transactionData.status !== "success") {
        return null;
      }

      // Read necessary data
      const receiverUid = transactionData.receiverUid;
      const amount = transactionData.amount;
      const senderUid = transactionData.senderUid;

      // If there's no receiver UID, we can't send a notification
      if (!receiverUid) {
        console.log("No receiverUid found in transaction.");
        return null;
      }

      try {
        // Fetch sender's data to get their name
        const senderDoc = await admin.firestore()
            .collection("users")
            .doc(senderUid)
            .get();
        let senderName = "Someone";
        if (senderDoc.exists) {
          senderName = senderDoc.data().username || "Someone";
        }

        // Fetch receiver's data to get the FCM token
        const receiverDoc = await admin.firestore()
            .collection("users")
            .doc(receiverUid)
            .get();

        if (!receiverDoc.exists) {
          console.log(`Receiver ${receiverUid} not found.`);
          return null;
        }

        const receiverData = receiverDoc.data();
        const fcmToken = receiverData.fcmToken;

        if (!fcmToken) {
          console.log(`Receiver ${receiverUid} does not have an FCM token.`);
          return null;
        }

        // Fetch receiver's wallet to get new balance
        const walletDoc = await admin.firestore()
            .collection("users")
            .doc(receiverUid)
            .collection("wallet")
            .doc("main")
            .get();

        let newBalanceStr = "";
        if (walletDoc.exists) {
          const bal = walletDoc.data().balance;
          if (bal !== undefined) {
            newBalanceStr = ` New Balance: ₹${bal}`;
          }
        }

        // Create the notification payload
        const payload = {
          notification: {
            title: "Money Received! 💰",
            body: `You received ₹${amount} from ${senderName}.${newBalanceStr}`,
          },
          data: {
            type: "transfer_received",
            transactionId: context.params.transactionId,
          },
        };

        // Send the notification using firebase-admin
        const response = await admin.messaging()
            .sendToDevice(fcmToken, payload);

        console.log(`Successfully sent message to ${receiverUid}:`, response);
        return response;
      } catch (error) {
        console.error("Error sending notification:", error);
        return null;
      }
    });
