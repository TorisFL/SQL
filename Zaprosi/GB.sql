SELECT 
    g.GameID,
    g.Title,
    SUM(od.Quantity) AS TotalSold
FROM 
    Games g
JOIN 
    OrderDetails od
ON 
    g.GameID = od.GameID
GROUP BY 
    g.GameID, g.Title
ORDER BY 
    TotalSold DESC;