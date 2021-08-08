const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().functions);
const db = admin.firestore();

exports.chatMessage = functions.firestore.document("message/{messageKey}/timestamp/{timestamp}").onCreate(async (snapshot, context)=>{
    if(!snapshot.exists){
        console.log("Data does not exist");
        return;
    }
    var messageData = snapshot.data();
    var messageKey = context.params.messageKey;
    var senderToken = messageKey.replace("-","").replace(messageData.token, "");
    const db = admin.firestore();
    db.collection("user").doc(senderToken).get().then(doc=> {
        if(!doc.exists){
            console.log("No data exist");
        }else{
            var token = doc.data().fcmToken;
            var payload = {
                notification: {title: messageData.name, body: messageData.message, sound: "default"},
                data: {click_action: "FLUTTER_NOTIFICATION_CLICK", message: "Sample Push Message", 
                name: messageData.name, token: messageData.token, image: messageData.image, screen: "chat"}
            }
            try{
                console.log("Notification sent successfully");
                admin.messaging().sendToDevice(token,payload);
            }catch(e){
                console.log("Error while sending notification :", e);
            }
        }
    });
});

exports.commentNotification = functions.firestore.document("post/{postTimestamp}/comments/{commentTimestamp}").onCreate(async (snapshot, context)=>{
    if(!snapshot.exists){
        console.log("Data does not exist");
        return;
    }
    var commentData = snapshot.data();
    const db = admin.firestore();
    db.collection("user").doc(commentData.postToken).get().then(doc=> {
        if(!doc.exists){
            console.log("No data exist");
        }else{
            console.log("")
            var token = doc.data().fcmToken;
            var payload = {
                notification: {title: commentData.name, body: commentData.comment, sound: "default"},
                data: {click_action: "FLUTTER_NOTIFICATION_CLICK", message: "Sample Push Message"}
            }
            try{
                console.log("Notification sent successfully to :", token);
                admin.messaging().sendToDevice(token,payload);
            }catch(e){
                console.log("Error while sending notification :", e);
            }
        }
    });
});

exports.newUserNotification = functions.firestore.document("user/{userId}").onCreate(async (snapshot, context)=>{
    if(!snapshot.exists){
        console.log("Data does not exist");
        return;
    }
    var userData = snapshot.data();
    var userName = userData["user_name"];
    const db = admin.firestore();
    db.collection("allUserToken").doc("fcmToken").get().then(doc=> {
        if(!doc.exists){
            console.log("No data exist");
        }else{
            var allUserTokenArray = doc.data().tokens;
            console.log("All User Tokens :", allUserTokenArray);
            var payload = {
                notification: {title: userName+" Just joined Good Quotes", body: "Welcome "+userName, sound: "default"},
                data: {click_action: "FLUTTER_NOTIFICATION_CLICK", message: "Sample Push Message"}
            }
            try{
                console.log("Notification sent successfully to :", allUserTokenArray);
                admin.messaging().sendToDevice(allUserTokenArray,payload);
            }catch(e){
                console.log("Error while sending notification :", e);
            }
        }
    });
});

exports.userPostNotification = functions.firestore.document("post/{postId}").onCreate(async (snapshot, context)=>{
    if(!snapshot.exists){
        console.log("Data does not exist");
        return;
    }

    var postData = snapshot.data();
    var postersId = postData["posters_id"];

    console.log("Posters id :", postersId);

    var followerIdList = [];
    var followerFCMTokenList = [];

    const db = admin.firestore();
    db.collection("user").doc(postersId).get().then(doc => {
        var followersData = doc.data()["follower"];
        for(let i=0; i<followersData.length; i++){
            followerIdList.push(followersData[i]["token"]);
        }
        
        db.collection("user").where(admin.firestore.FieldPath.documentId(), 'in', followerIdList).get().then( followersDetails => {
            for(let i=0; i<followersDetails.docs.length; i++){
                console.log("Each FCM token :", followersDetails.docs[i].data().fcmToken);
                followerFCMTokenList.push(followersDetails.docs[i].data().fcmToken);
            }
            console.log("FCM token list :", followerFCMTokenList);

            var payload = {
                notification: {title: postData["posters_name"] + " posted a new post", body: postData["quote"], sound: "default"},
                data: {click_action: "FLUTTER_NOTIFICATION_CLICK", message: "Sample Push Message"}
            }
            try{
                console.log("Notification sent successfully to :", followerFCMTokenList);
                admin.messaging().sendToDevice(followerFCMTokenList, payload);
            }catch(e){
                console.log("Error while sending notification :", e);
            }
        });
    });
});