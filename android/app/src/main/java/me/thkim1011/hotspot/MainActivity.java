package me.thkim1011.hotspot;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.webkit.WebView;

public class MainActivity extends AppCompatActivity {
    private WebView mWebView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        mWebView = (WebView) this.findViewById(R.id.webview);
        mWebView.loadUrl("http://google.com");

        setContentView(mWebView);
    }
}
