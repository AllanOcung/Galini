/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");

admin.initializeApp();

// Gmail SMTP settings for Nodemailer
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "allansocung137@gmail.com", // Replace with your email
    pass: "Rebbllans21", // Replace with your email password or app password
  },
});

exports.sendApprovalEmail = functions.firestore
    .document("therapist_requests/{requestId}")
    .onUpdate(async (change, context) => {
      const newData = change.after.data();
      const previousData = change.before.data();

      // Check if status changed to "approved"
      if (newData.status === "approved" && previousData.status !== "approved") {
        const email = newData.email; // Therapist's email
        const name = newData.name; // Therapist's name

        // Email content
        const mailOptions = {
          from: "allansocung137@gmail.com.com",
          to: email,
          subject: "Approval Notification",
          text: `Hello ${name},\n\nYour request has been approved.` +
                 `Welcome to Galini Plus!`,
          html: `<p>Hello <strong>${name}</strong>,</p><p>Your request`+
                 `has been approved.` +
                ` Welcome to Galini Plus!</p>`,
        };

        // Send email
        try {
          await transporter.sendMail(mailOptions);
          console.log("Email sent successfully");
        } catch (error) {
          console.error("Error sending email:", error);
        }
      }
    });
