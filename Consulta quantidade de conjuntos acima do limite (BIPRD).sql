SELECT t1.[IdAgente]
      ,t1.[Ano]
      ,t1.[Mes]
	  ,COUNT(t1.IdAgente) AS QtdConjAcimaLim
	  ,(SELECT COUNT(t3.IdAgente) 
		FROM [dw_InterfaceSAS].[dbo].[IndContDecFecMvlConj] t3
		WHERE t1.[IdAgente] = t3.[IdAgente] AND t1.[Ano] = t3.[Ano] AND t1.[Mes] = t3.[Mes]) AS QtdTotalConj
  FROM [dw_InterfaceSAS].[dbo].[IndContDecFecMvlConj] t1
  INNER JOIN [dw_InterfaceSAS].[dbo].[IndContinuidadeConjAnual] t2
  ON t1.[IdAgente] = t2.[IdAgente] AND t1.[Ano] = [t2].[PrdCptAnoInd] AND [t1].[IdeCnjUndCnm] = [t2].[IdeCnjUndCnm]
  WHERE t1.[Ano] > 2015 AND t1.[DEC] > [t2].[DECLimiteAnual]
  GROUP BY T1.[Ano], t1.[Mes], t1.[IdAgente]