# mgm_app

Member-Get-Member Flutter app.

## Executar

```bash
flutter pub get
flutter run -d chrome --web-port 3000
```

### Firebase (Web) via .env (opcional para desenvolvimento)

Crie `apps/mgm_app/.env` com as variáveis:

```
FIREBASE_API_KEY=YOUR_API_KEY
FIREBASE_AUTH_DOMAIN=your-app.firebaseapp.com
FIREBASE_PROJECT_ID=your-app
FIREBASE_STORAGE_BUCKET=your-app.appspot.com
FIREBASE_MESSAGING_SENDER_ID=000000000000
FIREBASE_APP_ID=1:000000000000:web:abcdef123456
INSIGHTS_FUNCTION_REGION=us-central1
```

No Android/iOS use os arquivos nativos (`google-services.json` e `GoogleService-Info.plist`).
