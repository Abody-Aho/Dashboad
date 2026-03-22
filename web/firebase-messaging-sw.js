importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.12.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyAoK7_-KbIPfV_U2J5qtIDXh8bN_SyEv14",
  authDomain: "flymarket-34847.firebaseapp.com",
  projectId: "flymarket-34847",
  messagingSenderId: "571768389468",
  appId: "1:571768389468:web:2261fae6418bddbd6e0b99",
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  self.registration.showNotification(payload.notification.title, {
    body: payload.notification.body,
    data: payload.data
  });
});