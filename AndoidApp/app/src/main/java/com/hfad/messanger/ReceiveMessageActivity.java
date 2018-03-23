package com.hfad.messanger;

import android.content.Intent;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.widget.TextView;
import android.widget.Toast;

public class ReceiveMessageActivity extends AppCompatActivity {

    public static final String EXTRA_MESSAGE = "message";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_receive_message);
        Intent intent = getIntent();
        String message = intent.getStringExtra(EXTRA_MESSAGE);
//        String message = intent.getStringExtra(Intent.EXTRA_TEXT);
        TextView textView = (TextView) findViewById(R.id.message);
        textView.setText(message);
    }
}
