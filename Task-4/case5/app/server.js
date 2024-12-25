const express = require('express');
const app = express();

const exchangeRates = {
    USD: 1,
    IDR: 15000,
};

const formatCurrency = (amount, currency) => {
    try {
        return new Intl.NumberFormat('id-ID', { style: 'currency', currency }).format(amount);
    } catch (err) {
        console.error(`Error formatting currency: ${err.message}`);
        return `Invalid Currency: ${currency}`;
    }
};

app.use(express.static('public'));

app.get('/convert', (req, res) => {
    const { amount, from, to } = req.query;

    if (!amount || !from || !to) {
        return res.json({ error: 'Missing parameters' });
    }

    const numericAmount = parseFloat(amount);
    if (isNaN(numericAmount)) {
        return res.json({ error: 'Amount must be a valid number' });
    }

    if (!exchangeRates[from] || !exchangeRates[to]) {
        return res.json({ error: 'Unsupported currency' });
    }

    const converted = (numericAmount / exchangeRates[from]) * exchangeRates[to];
    const formattedConverted = formatCurrency(converted, to);
    res.json({
        originalAmount: formatCurrency(numericAmount, from),
        converted: formattedConverted,
    });
});

const PORT = 3000;
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
