import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart' as auth;

class NotificationService {
  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
        "type": "service_account",
        "project_id": "hedieaty-b98ec",
        "private_key_id": "30f6ae56e85e90f70da3142ca0f33ded71170fc0",
        "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD1y1aPqr8x2En4\n+fPHRfAM5janaGg0drS8ajpWZHTr6HCNpG1zegH6lI88aH8LFtA4jBZIASgS2V15\n6U8VaFpvbbqs69Ms14aSee/Zj7SJ28yVxCKZaSKT9nozWPG0DlxgaFWDRXzKhUGX\nYJQ0vl/Gst+hpxMXK5dswQqQ6DvPVUS5cKjaZ8PBqWL3ZStIZhXkeME4wXK2GNUX\nq7GJ9UcuHyxM2pftMK0dMlOH5/5dGg2IBHULve8gtw4CBG5B1vy9uItCNXwtfBU8\nWM7+Ygv47xvVaUnapWubeH26rokduHpMY1C+AGFaX2mBOuPPZYH+4Zh5IKqa5qPH\npayfrhovAgMBAAECggEAGMMwCNBIa9Kg/TLdUu2iVgJZbjswCF0PL046a1q6hsvH\njxWKK1CW43JVDd5vMiRNvOysD/wB2AhLCQ2uuHbnaYNyA5rMjx91gMtFFTOLmjnp\nHguA+tijManqvMKQszWhK9tHBi8Zd+O97Gy/8aJeTsvViNkmrLZpDn1SPbAP2n7H\nnhVbEJDANGo9AUPHQ9AHl776KuAlyfcBG+bsdbUYqolkJZhIyOfboL1D9EZ0ax58\nxHtFztCIqGoMixz+s9yeApZ5XGrZPA1SGbbxmiIlFSWRnIVUFjHSOI6pSwHE8xmq\nFCgl+uwcp9TtMMYqKTdacuYZsqj4V9xtlhWG1HyzrQKBgQD9/BeVO/W54A6eX3iO\nEJz6kW6tgpV+zZqWKMNnrPju1e+kEXQdAqQQGW4dKxGDEVzjnOybH800Aah8ZuQx\nXdiBra8cRkoiI+kyQDwo+7Dxng7F5rRxH6FlfaHPbBNoM3C0s95ANatu4Nmf0OTj\nYnuWKRP1XEZODsYf4Hb4HvMLKwKBgQD3vpvvbV2iKBO5WV9D63L5y1SaOLV0nIZs\nkqoo65nduBbEswmkdE4NLomUbMH7hBR8QSEbWRfQvUhD0hXfh8J2+8dJ1/L2+cp7\nQ+Eejaosbm532wMRPdcM3ih/hUsLUtPuFPkRk6Fxk024kAsiFc8pTN+zo64j+9xf\nl2vuaPsbDQKBgFXsIaJH3ZJbPTbQv3z4G9Mcvh+OzLpQHhrsgWaierh5wY90pB5o\nVU5o+/p8Jnl7tzv9S4ITGR2d7fzf5hTZVbRRKKtdEBlKospwNqn6s9qZiQ/kQ2j9\ntWEbRlFgk5QtytQnAWohffSNtrG9PqG6IGslTG42IEap8ta33ieEeN5vAoGBAOtb\nVWCcEXvffv1yfiJUJ6JPHEx220uw97NlkenWCRKttFOhkuN86jlzoJg0ygRbceqp\nJP6KISnY6DIl/0mf+4p1ntn0IYmnvEhmMBOKmcQkFSYgFkXm7cn3s5mR070qLtPb\ncNLV4WW4fvl7PlhfR7MAqPRL5z+gIbdebtbLPOJxAoGAL0H/qLmJ0je2iRlNYjUJ\nzjCN5ODMLdUOoQ+l+ADOg46DdM0Mxw9Gb0tlgH7d3oMDsF/5cbnBwhnXim3Jw7ba\nnof9i9PKJ+Atle5oz0vvrfVFt2RGZKEJJ9elmZQJSUWMPZU362OGQClrRCdoF+o2\nNC1dsCWTFCNulgvjZxTAtOA=\n-----END PRIVATE KEY-----\n",
        "client_email": "heditymiso@hedieaty-b98ec.iam.gserviceaccount.com",
        "client_id": "108536225678343614300",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/heditymiso%40hedieaty-b98ec.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];
    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );
    auth.AccessCredentials credentials =
    await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
        scopes,
        client);
    client.close();

    return credentials.accessToken.data;
  }

  Future<void> sendNotification(String deviceToken, String title, String body) async {
    final String accessToken = await getAccessToken();
    String endpointFCM =
        'https://fcm.googleapis.com/v1/projects/hedieaty-b98ec/messages:send';
    final Map<String, dynamic> message = {
      "message": {
        "token": deviceToken,
        "notification": {"title": title, "body": body},
        "data": {
          "route": "serviceScreen",
        }
      }
    };

    final http.Response response = await http.post(
      Uri.parse(endpointFCM),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken'
      },
      body: jsonEncode(message),
    );

    if (response.statusCode == 200) {
      print('Notification sent successfully');
    } else {
      print('Failed to send notification: ${response.body}');
    }
  }



}

