# 🚀 MGM Insights Backend

Backend alternativo para a função `insights` que funciona **sem Firebase Blaze**.

## 🎯 O que faz

- ✅ Endpoint `/insights` que recebe perguntas em PT-BR
- ✅ Retorna KPIs, gráficos e análises inteligentes
- ✅ Funciona como alternativa à Cloud Function do Firebase
- ✅ **Totalmente gratuito** - sem necessidade de plano pago

## 🚀 Deploy Rápido

### Opção 1: Render.com (Recomendado - Gratuito)

1. **Fork/Clone** este repositório
2. **Acesse** [render.com](https://render.com) e crie conta
3. **New Web Service** → Connect GitHub → Selecione o repo
4. **Configuração:**
   - **Name:** `mgm-insights`
   - **Environment:** `Node`
   - **Build Command:** `npm install`
   - **Start Command:** `npm start`
5. **Deploy** e copie a URL (ex: `https://mgm-insights.onrender.com`)

### Opção 2: Vercel (Gratuito)

1. **Acesse** [vercel.com](https://vercel.com)
2. **Import Project** → GitHub → Selecione o repo
3. **Deploy** automático

### Opção 3: Local (Desenvolvimento)

```bash
cd backend-insights
npm install
npm start
```

## 🔧 Configuração no App

Após o deploy, adicione no seu `.env`:

```env
INSIGHTS_ENDPOINT_URL=https://sua-url.onrender.com/insights
```

## 📊 Como usar

### Request
```json
POST /insights
{
  "question": "Como estão minhas conversões nos últimos 7 dias?"
}
```

### Response
```json
{
  "answer": "📊 Resumo dos últimos 7 dias...",
  "kpis": {
    "referralFunnel": {
      "clicked": 25,
      "converted": 8,
      "conversionRate": 0.32
    }
  },
  "charts": [...]
}
```

## 🎨 Personalização

- **KPIs:** Edite `mockKpis` em `server.js`
- **Respostas:** Modifique a lógica de `answer` 
- **Banco de dados:** Conecte ao seu Firestore/MySQL/PostgreSQL

## 🔒 Segurança

- CORS habilitado para desenvolvimento
- Validação de input básica
- Em produção, adicione autenticação se necessário

## 📱 Teste

```bash
curl -X POST https://sua-url.onrender.com/insights \
  -H "Content-Type: application/json" \
  -d '{"question": "Teste"}'
```

---

**Pronto!** Agora seu app funciona sem Firebase Blaze. 🎉
