-- Runtime smoke test for the Codespace and CI environment.
-- Error severity 16+ is propagated by sqlcmd via the -b -V 16 flags.
SET NOCOUNT ON;
SET XACT_ABORT ON;
GO

SELECT @@VERSION AS sql_server_surumu;
GO

IF DB_ID(N'btk') IS NULL
BEGIN
    CREATE DATABASE btk;
END;
GO

IF DB_ID(N'btk') IS NULL
BEGIN
    THROW 51000, 'btk database could not be created.', 1;
END;
GO

USE btk;
GO

SELECT N'BTK_SQL_SMOKE_OK' AS smoke_test_marker;
SELECT name AS veritabani FROM sys.databases WHERE name = N'btk';
GO
