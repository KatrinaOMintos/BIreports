SELECT
	'OutstandingInvestments',
	SUM(CASE 
			WHEN t.currencyIsoCode = 978 THEN t.outstanding_investments 
			ELSE t.outstanding_investments * cer.rate 
		END) AS 'outstanding_investments_eur'
FROM
	(
	SELECT
		l.currencyIsoCode,
		SUM(l.remainingAmount - l.lenderShare) AS 'outstanding_investments'
	FROM
		 m_loans AS l 
	WHERE
		l.status = 4
	GROUP BY
		l.currencyIsoCode) AS t
LEFT JOIN m_currency_exchange_rates AS cer ON
	t.currencyIsoCode = cer.fromCurrencyIsoCode
	AND cer.toCurrencyIsoCode = 978


SELECT
	SUM(CASE 
			WHEN t.currencyIsoCode = 978 THEN t.availableForInvestment 
			ELSE t.availableForInvestment * cer.rate 
		END) AS 'availableForInvestment_eur'
FROM
	(
	SELECT
		l.currencyIsoCode,
		SUM(l.availableForInvestment) AS 'availableForInvestment'
	FROM
		 m_loans AS l 
		 JOIN m_currency AS cu ON (l.currencyIsoCode = cu.isoCode)
	WHERE
		l.status = 4
		AND l.availableForInvestment >= cu.primaryMarketMinimumAmount
	GROUP BY
		l.currencyIsoCode) AS t
LEFT JOIN m_currency_exchange_rates AS cer ON
	t.currencyIsoCode = cer.fromCurrencyIsoCode
	AND cer.toCurrencyIsoCode = 978;
	

-- old

SELECT
	cu.abbreviation AS 'currency',
	SUM(l.availableForInvestment) AS 'amount'
FROM m_loans As l
 JOIN m_currency AS cu ON (l.currencyIsoCode = cu.isoCode)
WHERE
	l.`status` = 4
	AND l.availableForInvestment >= cu.primaryMarketMinimumAmount
GROUP BY
	cu.abbreviation;

	
	SELECT * FROM m_currency_exchange_rates;
	
SELECT
	cu.abbreviation AS 'currency',
	SUM(l.availableForInvestment) AS 'amount', cer.rate
FROM m_loans As l

 JOIN m_currency AS cu ON (l.currencyIsoCode = cu.isoCode)
 LEFT JOIN m_currency_exchange_rates AS cer ON
	cu.isoCode = cer.fromCurrencyIsoCode 
	AND cer.toCurrencyIsoCode = 978
WHERE
	l.`status` = 4
	AND l.availableForInvestment >= cu.primaryMarketMinimumAmount
GROUP BY
	cu.abbreviation;