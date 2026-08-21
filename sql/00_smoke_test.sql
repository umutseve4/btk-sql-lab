-- Duman testi: Codespace acildiktan sonra bunu calistir.
-- Terminalden: sqlcmd -S localhost -U sa -P 'Btk_Lab_2026!' -C -i sql/00_smoke_test.sql
SELECT @@VERSION AS sql_server_surumu;

IF DB_ID('btk') IS NULL
    CREATE DATABASE btk;
GO

USE btk;
GO

SELECT name AS veritabani FROM sys.databases;
