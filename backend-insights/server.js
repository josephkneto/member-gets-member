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

    // Simular dados de KPIs (em produção, você conectaria ao seu banco)
    const mockKpis = {
      referralFunnel: {
        clicked: 25,
        installed: 18,
        registered: 12,
        converted: 8,
        conversionRate: 0.32,
        windowDays: 7
      },
      topReferrers: [
        { userId: 'user1', totalConverted: 5 },
        { userId: 'user2', totalConverted: 3 },
        { userId: 'user3', totalConverted: 2 }
      ],
      rewardsSummary: { totalPoints: 450 }
    };

    const mockCharts = [
      {
        id: 'funnelByDay',
        series: [
          { date: '2025-01-20', clicked: 8, installed: 6, registered: 4, converted: 3 },
          { date: '2025-01-21', clicked: 6, installed: 4, registered: 3, converted: 2 },
          { date: '2025-01-22', clicked: 11, installed: 8, registered: 5, converted: 3 }
        ]
      }
    ];

    // Gerar resposta baseada na pergunta
    let answer = '';
    const questionLower = question.toLowerCase();
    
    if (questionLower.includes('conversão') || questionLower.includes('conversoes')) {
      answer = `📊 **Resumo dos últimos ${mockKpis.referralFunnel.windowDays} dias:**\n\n` +
               `• **Clicados:** ${mockKpis.referralFunnel.clicked} pessoas\n` +
               `• **Registrados:** ${mockKpis.referralFunnel.registered} pessoas\n` +
               `• **Convertidos:** ${mockKpis.referralFunnel.converted} pessoas\n` +
               `• **Taxa de Conversão:** ${(mockKpis.referralFunnel.conversionRate * 100).toFixed(1)}%\n\n` +
               `🎯 **Análise:** Sua taxa de conversão está ${mockKpis.referralFunnel.conversionRate > 0.3 ? 'acima da média' : 'na média'} do setor. ` +
               `Foque em melhorar a experiência pós-clique para aumentar conversões.`;
    } else if (questionLower.includes('pontos') || questionLower.includes('recompensas')) {
      answer = `💰 **Resumo de Recompensas:**\n\n` +
               `• **Total de Pontos:** ${mockKpis.rewardsSummary.totalPoints} pts\n` +
               `• **Período:** Últimos ${mockKpis.referralFunnel.windowDays} dias\n\n` +
               `🏆 **Dica:** Continue compartilhando seus links! Cada conversão vale pontos extras.`;
    } else if (questionLower.includes('top') || questionLower.includes('melhores')) {
      answer = `🏅 **Top Referenciadores:**\n\n` +
               `1. **User1:** ${mockKpis.topReferrers[0].totalConverted} conversões\n` +
               `2. **User2:** ${mockKpis.topReferrers[1].totalConverted} conversões\n` +
               `3. **User3:** ${mockKpis.topReferrers[2].totalConverted} conversões\n\n` +
               `💡 **Estratégia:** Analise o que esses usuários fazem de diferente e replique!`;
    } else {
      answer = `🤔 **Análise Geral:**\n\n` +
               `Com base na sua pergunta "${question}", aqui estão os insights:\n\n` +
               `• **Funil de Conversão:** ${mockKpis.referralFunnel.clicked} → ${mockKpis.referralFunnel.converted} (${(mockKpis.referralFunnel.conversionRate * 100).toFixed(1)}%)\n` +
               `• **Pontos Acumulados:** ${mockKpis.rewardsSummary.totalPoints}\n` +
               `• **Período:** Últimos ${mockKpis.referralFunnel.windowDays} dias\n\n` +
               `📈 **Recomendação:** Foque em melhorar a qualidade dos leads para aumentar a taxa de conversão.`;
    }

    res.json({
      answer,
      kpis: mockKpis,
      charts: mockCharts
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
