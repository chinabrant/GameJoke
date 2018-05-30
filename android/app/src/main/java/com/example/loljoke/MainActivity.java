package com.example.loljoke;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;

import com.avos.avoscloud.AVException;
import com.avos.avoscloud.AVFile;
import com.avos.avoscloud.AVOSCloud;
import com.avos.avoscloud.LogUtil;
import com.avos.avoscloud.SaveCallback;

import java.io.File;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

public class MainActivity extends FlutterActivity {

  private static final String CHANNEL = "joke.brant.com/upload";

  private Result kResult = null;
    private AVFile kFile = null;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);

    // 初始化参数依次为 this, AppId, AppKey
    AVOSCloud.initialize(this,"a4h8AfUwvYJFsiwl0JBv9Fu5","4ywjc0gCkPxkEQMImhSjKurf");


    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodCallHandler() {
                @Override
                public void onMethodCall(MethodCall call, Result result) {
                    System.out.println("method:" + call.method);
                    if (call.method.equals("uploadImage")) {

                        kResult = result;
                        saveImagePath((String) call.arguments);

                    } else {
                        result.notImplemented();
                    }
                }
            }

           );
  }

  private void saveImagePath(String path) {
    try {

      BitmapFactory.Options bmOptions = new BitmapFactory.Options();
      Bitmap bitmap = BitmapFactory.decodeFile(path,bmOptions);
        System.out.println("width:" + bitmap.getWidth());

      kFile = AVFile.withAbsoluteLocalPath("android.png", path);

      System.out.println(kFile.getSize() + "");

      kFile.addMetaData("width", bitmap.getWidth());
        kFile.addMetaData("height", bitmap.getHeight());
        bitmap = null;

        kFile.saveInBackground(new SaveCallback() {
            @Override
            public void done(AVException e) {
                if (e == null) {
                    System.out.println("保存成功");
                    kResult.success(kFile.getObjectId());
                } else {
                    LogUtil.log.d("保存失败");
                    System.out.println("保存失败: " + e.getMessage());
                    kResult.notImplemented();
                }
            }
        });

    } catch (Exception e) {
      System.out.println("保存失败：" + e.getMessage());

      kResult.notImplemented();
    }
  }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        System.out.println("===> onDestroy");
    }
}
