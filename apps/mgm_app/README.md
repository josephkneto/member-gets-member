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

### Sem Blaze (alternativa)
- Você pode evitar o Blaze definindo `INSIGHTS_ENDPOINT_URL` no `.env` para um HTTPS seu (Cloud Run/Apps Script/Render/etc.) que implemente o contrato da função `insights`. O app chamará esse endpoint diretamente no web e mobile, pulando Callable Functions.
```

INSIGHTS_ENDPOINT_URL=https://seu-endpoint/insights

```

```

No Android/iOS use os arquivos nativos (`google-services.json` e `GoogleService-Info.plist`).
