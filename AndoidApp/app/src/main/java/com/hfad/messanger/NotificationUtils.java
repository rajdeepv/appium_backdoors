package com.hfad.messanger;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;
import android.support.v4.app.NotificationCompat;
import android.support.v4.content.ContextCompat;

/**
 * Created by rajdeepvarma on 03/12/2017.
 */

public class NotificationUtils {

    public static void showNotification(Context context, String text){
        Intent notificationIntent = new Intent(context, ReceiveMessageActivity.class);
        notificationIntent.setAction("com.example.action");
        notificationIntent.putExtra(ReceiveMessageActivity.EXTRA_MESSAGE,text);


        PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT);


        Notification notification =  new NotificationCompat.Builder(context)
                .setContentTitle(text)
                .setSmallIcon(android.R.drawable.star_on)
                .setContentIntent(pendingIntent)
                .setColor(ContextCompat.getColor(context, R.color.colorAccent))
                .setPriority(Notification.PRIORITY_MAX)
                .setDefaults(Notification.DEFAULT_VIBRATE)
                .setAutoCancel(true)
                .build();

        NotificationManager mNotificationManager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
        mNotificationManager.notify(55, notification);

    }
}
