const express = require('express');
const app = express();

const exchangeRates = {
    USD: 1,
    IDR: 15000,
};

const formatCurrency = (amount, currency) => {
    return new Intl.NumberFormat('id-ID', { style: 'currency', currency }).format(amount);
};

app.use(express.static('public'));

app.get('/convert', (req, res) => {
    const { amount, from, to } = req.query;

    if (!amount || !from || !to) {
        return res.json({ error: 'Missing parameters' });
    }

    if (!exchangeRates[from] || !exchangeRates[to]) {
        return res.json({ error: 'Unsupported currency' });
    }

    const converted = (amount / exchangeRates[from]) * exchangeRates[to];
    res.json({ 
        converted: formatCurrency(converted, to) 
    });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
