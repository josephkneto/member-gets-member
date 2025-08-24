import express from 'express';
import cors from 'cors';

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Endpoint principal de insights
app.post('/insights', async (req, res) => {
  try {
    const { question = '' } = req.body;

    if (!question.trim()) {
      return res.status(400).json({
        error: 'Pergunta é obrigatória'
      });
    }

    // TODO: Em produção, conectar ao banco de dados real
    // Por enquanto, retornar mensagem informativa
    const questionLower = question.toLowerCase();

    let answer = '';
    let kpis = {};
    let charts = [];

    if (questionLower.includes('conversão') || questionLower.includes('conversoes')) {
      answer = `📊 **Análise de Conversão:**\n\n` +
               `• **Status:** Nenhum dado de conversão disponível ainda\n` +
               `• **Período:** Últimos 7 dias\n\n` +
               `🎯 **Recomendação:** Comece compartilhando seus links de referência para gerar dados de conversão. ` +
               `Cada pessoa que usar seu link será rastreada e você poderá ver métricas reais.`;
    } else if (questionLower.includes('pontos') || questionLower.includes('recompensas')) {
      answer = `💰 **Análise de Recompensas:**\n\n` +
               `• **Status:** Nenhum ponto acumulado ainda\n` +
               `• **Período:** Últimos 7 dias\n\n` +
               `🏆 **Como ganhar pontos:**\n` +
               `1. Compartilhe seu link de referência\n` +
               `2. Quando alguém usar seu link, você ganha pontos\n` +
               `3. Cada conversão vale pontos extras\n\n` +
               `💡 **Dica:** Comece compartilhando agora mesmo!`;
    } else if (questionLower.includes('top') || questionLower.includes('melhores')) {
      answer = `🏅 **Análise de Performance:**\n\n` +
               `• **Status:** Nenhum dado de performance disponível ainda\n` +
               `• **Período:** Últimos 7 dias\n\n` +
               `🚀 **Para aparecer no ranking:**\n` +
               `1. Compartilhe seus links de referência\n` +
               `2. Ajude outras pessoas a se registrarem\n` +
               `3. Monitore suas métricas no dashboard\n\n` +
               `💪 **Seja o primeiro a aparecer no topo!**`;
    } else if (questionLower.includes('desempenho') || questionLower.includes('semana')) {
      answer = `📈 **Análise de Desempenho Semanal:**\n\n` +
               `• **Status:** Nenhum dado de desempenho disponível ainda\n` +
               `• **Período:** Últimos 7 dias\n\n` +
               `📊 **Métricas que você verá:**\n` +
               `• Número de cliques nos seus links\n` +
               `• Pessoas que se registraram\n` +
               `• Taxa de conversão\n` +
               `• Pontos acumulados\n\n` +
               `🎯 **Para começar:** Vá ao dashboard e clique em "Compartilhar" para gerar seu primeiro link!`;
    } else {
      answer = `🤔 **Análise Geral:**\n\n` +
               `Com base na sua pergunta "${question}", aqui estão os insights:\n\n` +
               `• **Status:** Nenhum dado disponível ainda\n` +
               `• **Período:** Últimos 7 dias\n\n` +
               `🚀 **Para gerar insights reais:**\n` +
               `1. Compartilhe seus links de referência\n` +
               `2. Monitore as métricas no dashboard\n` +
               `3. Faça perguntas específicas sobre conversões, pontos ou performance\n\n` +
               `💡 **Dica:** Quanto mais você usar o app, mais insights personalizados poderemos gerar!`;
    }

    res.json({
      answer,
      kpis: {
        referralFunnel: {
          clicked: 0,
          installed: 0,
          registered: 0,
          converted: 0,
          conversionRate: 0,
          windowDays: 7
        },
        topReferrers: [],
        rewardsSummary: { totalPoints: 0 }
      },
      charts: []
    });

  } catch (error) {
    console.error('Erro no endpoint insights:', error);
    res.status(500).json({
      error: 'Erro interno do servidor',
      details: error.message
    });
  }
});

// Endpoint de saúde
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Endpoint raiz
app.get('/', (req, res) => {
  res.json({
    name: 'MGM Insights Backend',
    version: '1.0.0',
    endpoints: {
      insights: 'POST /insights',
      health: 'GET /health'
    },
    usage: 'Envie POST para /insights com {"question": "sua pergunta"}'
  });
});

app.listen(port, () => {
  console.log(`🚀 MGM Insights Backend rodando na porta ${port}`);
  console.log(`📊 Endpoint: http://localhost:${port}/insights`);
  console.log(`💚 Saúde: http://localhost:${port}/health`);
});
