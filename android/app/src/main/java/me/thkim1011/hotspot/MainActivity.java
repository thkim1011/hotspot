package me.thkim1011.hotspot;

import android.content.Context;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

import com.google.firebase.database.DatabaseReference;
import com.google.firebase.database.FirebaseDatabase;

import java.io.FileWriter;
import java.io.IOException;


public class MainActivity extends AppCompatActivity implements SensorEventListener {

    private SensorManager mSensorManager;
    private Sensor mSensor;
    private DatabaseReference database;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
        mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_LINEAR_ACCELERATION);
        mSensorManager.registerListener(this, mSensor, SensorManager.SENSOR_DELAY_NORMAL);
        database = FirebaseDatabase.getInstance().getReference("thk_accel2");
    }

    @Override
    public void onAccuracyChanged(Sensor event, int accuracy) {

    }

    @Override
    public void onSensorChanged(SensorEvent event) {
        TextView accel_x = (TextView) findViewById(R.id.accel_x);
        TextView accel_y = (TextView) findViewById(R.id.accel_y);

        accel_x.setText("" + event.values[0]);
        accel_y.setText("" + event.values[1]);
        DatabaseReference node = database.push();
        node.child("time").setValue(event.timestamp);
        node.child("accel_x").setValue(event.values[0]);
        node.child("accel_y").setValue(event.values[1]);
    }

}
