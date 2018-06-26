package com.hfad.messanger;

import android.content.Intent;
import android.graphics.Typeface;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;

public class CreateMessageActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_create_message);
    }

    public void raiseToast(String message){
        Toast.makeText(this, message, Toast.LENGTH_LONG).show();
    }

    public EditText messageView(){
        return (EditText)findViewById(R.id.message);
    }


    public void onSendMessage(View view) {
        EditText editText = (EditText) findViewById(R.id.message);
        Intent intent = new Intent(this, ReceiveMessageActivity.class);
        String message = String.valueOf(editText.getText());
        intent.putExtra(ReceiveMessageActivity.EXTRA_MESSAGE,message);
        startActivity(intent);

    }

    public void onBold(View view) {
        EditText editText = (EditText) findViewById(R.id.message);
        editText.setTypeface(null, Typeface.BOLD);
    }

    public void onItalic(View view) {
        EditText editText = (EditText) findViewById(R.id.message);
        editText.setTypeface(null, Typeface.ITALIC);
    }

    public void onIncreaseSize(View view) {
        EditText editText = (EditText) findViewById(R.id.message);
        float size = editText.getTextSize();
        editText.setTextSize(TypedValue.COMPLEX_UNIT_PX, (1+size));
    }
}
