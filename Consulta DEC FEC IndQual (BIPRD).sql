SELECT t1.[IdAgente]
      ,t1.[Ano]
      ,t1.[Mes]
      ,t1.[DECApuradoMensal]
	  ,t2.[DECLimiteAnual]
	  ,ROW_NUMBER() OVER (partition by t1.Ano,t1.Mes ORDER BY t1.[DECApuradoMensal] DESC) AS RnkDEC
	  ,(SELECT t1.[DECApuradoMensal] - t3.[DECApuradoMensal]
		    FROM [dw_InterfaceSAS].[dbo].[IndContDecFecMvlDist] t3
		    WHERE t1.[IdAgente] = t3.[IdAgente] AND
			   DATEFROMPARTS(t1.[Ano], t1.[Mes],1) = DATEADD(MONTH,+1,DATEFROMPARTS(t3.[Ano],t3.[Mes],1))
		) AS variacaoDEC
	  ,(t1.[DECINDApuradoMensal] + t1.[DECIPApuradoMensal]) AS DECi
	  ,(SELECT t4.Limite
	     FROM [dw_InterfaceSAS].[dbo].[SFE_DECi_FECi_Distribuidoras] t4
		 WHERE t4.Indicador = 1 AND t4.IdAgente = t1.IdAgente AND t4.Ano = t1.Ano) AS DECiLimiteAnual
      ,t1.[FECApuradoMensal]
      ,t2.[FECLimiteAnual]	 
	  ,ROW_NUMBER() OVER (partition by t1.Ano,t1.Mes ORDER BY t1.[FECApuradoMensal] DESC) AS RnkFEC
	  ,(SELECT t1.[FECApuradoMensal] - t3.[FECApuradoMensal]
		    FROM [dw_InterfaceSAS].[dbo].[IndContDecFecMvlDist] t3
		    WHERE t1.[IdAgente] = t3.[IdAgente] AND
			   DATEFROMPARTS(t1.[Ano], t1.[Mes],1) = DATEADD(MONTH,+1,DATEFROMPARTS(t3.[Ano],t3.[Mes],1))
		) AS variacaoFEC
		,(t1.[FECINDApuradoMensal] + t1.[FECIPApuradoMensal]) AS FECi
		,(SELECT t5.Limite
		   FROM [dw_InterfaceSAS].[dbo].[SFE_DECi_FECi_Distribuidoras] t5
		   WHERE t5.Indicador = 2 AND t5.IdAgente = t1.IdAgente AND t5.Ano = t1.Ano) AS FECiLimiteAnual
		,[DATULTATU]
  FROM [dw_InterfaceSAS].[dbo].[IndContDecFecMvlDist] t1
  LEFT JOIN [dw_InterfaceSAS].[dbo].[IndContinuidadeConcAnual] t2
  ON t1.[IdAgente] = t2.[IdAgente] AND t1.[Ano] = t2.[PrdCptAnoInd]
  WHERE t1.[Ano] > 2015 AND t1.Ano=2019-- AND t1.IdAgente = 4950 