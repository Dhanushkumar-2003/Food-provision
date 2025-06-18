import 'package:googleapis_auth/auth_io.dart';
// show ServiceAccountCredentials, clientViaServiceAccount;

class AceessServertoken {
  Future<String> serverKey() async {
    try {
      final scope = [
        'http://www.googleapis.com/auth/userinfo.email',
        'http://www.googleapis.com/auth/firebase.database',
        'http://www.googleapis.com/auth/firebase.messaging',
      ];
      final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson({
          "type": "service_account",
          "project_id": "project4-7bf02",
          "private_key_id": "32a3a4e0d32e86de66644e3e8f5b19f41ed79fd0",
          "private_key":
              "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDYwwb2vnbUz4t1\nL6JbJFBw1FiP6JTQl+skRXlXvlKpFsV7wVj2t81BRuxrevlNm9/NrzDJkpg4RILP\nUT1QE1e9BkbvcbpabucJizJhqd50hu/rsNZHnjOkZoHhHe+Ce2Ioq0TcGGUMDxUh\nJnOim6nxb1Oop9VrbIhp7P94YYHqiacvMsy3/kM7KzQh+5fl3hhR1sV8ilCNUdXB\nXts+EuTwK9CmUoCMvLEcFwdvzElX1oOsNeGu7gab5XcFvvm/j2i4DERF2oMfuMB3\n+CTRzt/qyYu7dQJiaX5p2qmY7P1Np+Gw3I7aj+W5d2PVGAL6oZt0SwEIZpYYXZbF\n554vaVX7AgMBAAECggEAD/RC1fRs21BaAQpm1nMqId6ElOBXMQc4J8JJTRuqtTFX\niw/5vqcGn3sF5F9NFtjrNGtkRDcwUavmk4sfin5HTe1hWTcIsqaeW1sjHoHEktUV\nDEbxbpyxS7S+cyr4jvpf3i3E8reE8HSdEdnlAZ9CzIzCHpQZJuqlG7l1kDm1DeW9\nzcupqACOrHlZHMiX8sOtl3GoRMvIkdXhiOSVLQkQ3W4bdkWhqJRJ4LzktcRWeJtP\nOqVeDxrdVTqFEsRVjrTcm3q66qvILOtDLShKxAytXAYuusVS8V9FxRNH5tdOWiiJ\nWMD1/9V7TIhsQRzWpjuWGzlPS09mN4nm0OHkWyhViQKBgQDxEplQ5drDS8yOFa0K\nc0L0DmwF0MV1xnAwonD7sfOhJmiXWSgSTljENFidCn1Y0ETJ7D6HRMyztla4mT+e\nVyT33Zp0Bp1WTdb3AzoTZEGRNHt1g3TdI0p+fqMhs4pzxD9mVdwv72NevI5ZkqBR\n3UzmPrdj7zQ0b+cwMVGjimLi/QKBgQDmLw+4loch6HgglWOMOck99hQQA916Zrof\nUkvcB43Rf596GXgPe19azC0nA0PIKaTgH3+6RbWZuYibXRXHwqaW+dzflMVmhk1p\nRJTjd6pH1CNOcRpTNH7N3xigbSYdH0DGb7xzwFZXOQCP5qqVH9SXsZ5OgHSEI+ag\n4dsi8OqaVwKBgQDDbkl+LKi5VBSjRu0+IIyxn5Nw73t0bAd9VeL0GKIiDSoTMALt\nPDh37tu7i8psGoL5kxxpupucQQByrEHH0mu0ySCyWL5qPbY8D5CgMdF5rqs7a/Ns\nZnS4sV78LjnaecjP5GEZNx8+qOtZsCVp2FbD/SncyQlwTRuFlSXSx5g83QKBgF0o\n1tgCNBbJGzU0wOFT0dq96UjCB7UuNk3O5NzcQc10NXsZK7o4WFNLJ0sOyzQLhqse\nlHczF1hr+pnGhrYeVYXtAjOK5omj+ViNZSTanZQMi22H4Puj115C2Ji1FCPdLj4h\nosfGJCuQ6mVTGd7YzxXF0Sg8XOvOC905C5OMpaZpAoGAR8jC4oYHGlmLwtBwgtl1\ns3NwBa5vad/tzxqL+m0YKRV7/prHSBSEHoFDCUBlyXVCnUSiJa0WbBTLLwRIIHAg\nofdnRSCHnmreSGSE9qEhsAG48NfdZGRJC+8H2PWxlthXiG3Snrqb9DwexUVdLqvt\n4okEOGtG+ZvZfDSNXfUVEMk=\n-----END PRIVATE KEY-----\n",
          "client_email":
              "firebase-adminsdk-ru7ta@project4-7bf02.iam.gserviceaccount.com",
          "client_id": "105890042693039000803",
          "auth_uri": "https://accounts.google.com/o/oauth2/auth",
          "token_uri": "https://oauth2.googleapis.com/token",
          "auth_provider_x509_cert_url":
              "https://www.googleapis.com/oauth2/v1/certs",
          "client_x509_cert_url":
              "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-ru7ta%40project4-7bf02.iam.gserviceaccount.com",
          "universe_domain": "googleapis.com",
        }),
        scope,
      );
      final serverkeys = client.credentials.accessToken.data;
      print("serverkey>>$serverkeys");
      return serverkeys;
    } catch (e) {
      print('errorr>>$e');
    }
    throw {print("hjj")};
  }
}
