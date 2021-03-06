SELECT t1.[IdAgente]
	,t1.[Ano]
	,t1.[Mes]
	,t1.[PGUCAT]+t1.[PGUCMTU]+t1.[PGUCMTNU]+t1.[PGUCBTU]+t1.[PGUCBTNU]
	+t1.[PGUCATDC]+t1.[PGUCMTUDC]+t1.[PGUCMTNUDC]+t1.[PGUCBTUDC]+t1.[PGUCBTNUDC] AS VlrCompTotal -- Valor total de compensaçõs nos 12 últimos meses
	,(SELECT ((t1.[PGUCAT]+t1.[PGUCMTU]+t1.[PGUCMTNU]+t1.[PGUCBTU]+t1.[PGUCBTNU]
			+t1.[PGUCATDC]+t1.[PGUCMTUDC]+t1.[PGUCMTNUDC]+t1.[PGUCBTUDC]+t1.[PGUCBTNUDC])
			- (t2.[PGUCAT]+t2.[PGUCMTU]+t2.[PGUCMTNU]+t2.[PGUCBTU]+t2.[PGUCBTNU]
			+t2.[PGUCATDC]+t2.[PGUCMTUDC]+t2.[PGUCMTNUDC]+t2.[PGUCBTUDC]+t2.[PGUCBTNUDC]))
		FROM [dw_InterfaceSAS].[dbo].[IndCompMensalMvlDist] t2
		WHERE t1.[IdAgente] = t2.[IdAgente] AND
			DATEFROMPARTS(t1.[Ano], t1.[Mes],1) = DATEADD(MONTH,+1,DATEFROMPARTS(t2.[Ano],t2.[Mes],1))
	) AS VariacaoComp
	,t1.[QTUCAT]+t1.[QTUCMTU]+t1.[QTUCMTNU]+t1.[QTUCBTU]+t1.[QTUCBTNU]
	+t1.[QTUCATDC]+t1.[QTUCMTUDC]+t1.[QTUCMTNUDC]+t1.[QTUCBTUDC]+t1.[QTUCBTNUDC] AS QtdCompTotal -- Valor total de compensaçõs nos 12 últimos meses
	,(SELECT ((t1.[QTUCAT]+t1.[QTUCMTU]+t1.[QTUCMTNU]+t1.[QTUCBTU]+t1.[QTUCBTNU]
			+t1.[QTUCATDC]+t1.[QTUCMTUDC]+t1.[QTUCMTNUDC]+t1.[QTUCBTUDC]+t1.[QTUCBTNUDC])
			- (t2.[QTUCAT]+t2.[QTUCMTU]+t2.[QTUCMTNU]+t2.[QTUCBTU]+t2.[QTUCBTNU]
			+t2.[QTUCATDC]+t2.[QTUCMTUDC]+t2.[QTUCMTNUDC]+t2.[QTUCBTUDC]+t2.[QTUCBTNUDC]))
		FROM [dw_InterfaceSAS].[dbo].[IndCompMensalMvlDist] t2
		WHERE t1.[IdAgente] = t2.[IdAgente] AND
			DATEFROMPARTS(t1.[Ano], t1.[Mes],1) = DATEADD(MONTH,+1,DATEFROMPARTS(t2.[Ano],t2.[Mes],1))
	) AS VariacaoQtdComp
	,[DATULTATU]
	--,[QTUCAT]		-- Qtd UC AT urbanas compensadas por violação do limite de continuidade no ano
	--,[PGUCAT]		-- Valor pago a UCs AT urbanas por violação dos limites de cont no ano
	--,[QTUCMTU]		-- Qtd UC MT urbanas compensadas por violação do limite de continuidade no ano
	--,[PGUCMTU]		-- Valor pago a UCs MT urbanas por violação dos limites de cont no ano
	--,[QTUCMTNU]		-- Qtd UC MT não urbanas compensadas por violação do limite de continuidade no ano
	--,[PGUCMTNU]		-- Valor pago a UCs MT não urbanas por violação dos limites de continuidade no ano
	--,[QTUCBTU]		-- Qtd UC BT urbanas compensadas por violação do limite de continuidade no ano
	--,[PGUCBTU]		-- Valor pago a UCs BT urbanas por violação dos limites de cont no ano
	--,[QTUCBTNU]		-- Qtde de UCs BT não urbanas compensadas por violação dos limites de continuidade no ano
	--,[PGUCBTNU]		-- Valor pago a UCs BT não urbanas por violação dos limites de continuidade no ano
	--,[QTUCATDC]		-- Qtde de UCs AT comp por violacao dos limites de DICRI
	--,[PGUCATDC]		-- Valor pago as UCs AT por violacao dos limites de DICRI
	--,[QTUCMTUDC]		-- Qtde de UCs MT urbanas comp por violacao dos limites de DICRI
	--,[PGUCMTUDC]		-- Valor pago as UCs MT urbanas por violacao dos limites de DICRI
	--,[QTUCMTNUDC]		-- Qtde de UCs MT não urbanas comp por violacao dos limites de DICRI
	--,[PGUCMTNUDC]		-- Valor pago as UCs MT não urbanas por violacao dos limites de DICRI
	--,[QTUCBTUDC]		-- Qtde de UCs BT urbanas comp por violacao dos limites de DICRI
	--,[PGUCBTUDC]		-- Valor pago as UCs BT urbanas por violacao dos limites de DICRI
	--,[QTUCBTNUDC]		-- Qtde de UCs BT não urbanas comp por violacao dos limites de DICRI
	--,[PGUCBTNUDC]		-- Valor pago as UCs BT não urbanas por violacao dos limites de DICRI
FROM [dw_InterfaceSAS].[dbo].[IndCompMensalMvlDist] t1
WHERE t1.[Ano] > 2015 -- AND t1.[IdAgente] = 4950 AND t1.[Mes] = 12 AND t1.[Ano] = 2019