package de.codevoid.corekeyboard;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;
import android.view.inputmethod.InputMethodManager;

public class NotificationReceiver extends BroadcastReceiver {
    static final String TAG = "PCKeyboard/Notification";
    static public final String ACTION_SHOW = "de.codevoid.corekeyboard.SHOW";
    static public final String ACTION_SETTINGS = "de.codevoid.corekeyboard.SETTINGS";

    private LatinIME mIME;

    NotificationReceiver(LatinIME ime) {
        super();
        mIME = ime;
        Log.i(TAG, "NotificationReceiver created, ime=" + mIME);
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        String action = intent.getAction();
        Log.i(TAG, "NotificationReceiver.onReceive called, action=" + action);

        if (action.equals(ACTION_SHOW)) {
            InputMethodManager imm = (InputMethodManager)
                context.getSystemService(Context.INPUT_METHOD_SERVICE);
            if (imm != null) {
                imm.showSoftInputFromInputMethod(mIME.mToken, InputMethodManager.SHOW_FORCED);
            }
        } else if (action.equals(ACTION_SETTINGS)) {
            Intent settingsIntent = new Intent(mIME, LatinIMESettings.class);
            settingsIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            context.startActivity(settingsIntent);
        }
    }
}
