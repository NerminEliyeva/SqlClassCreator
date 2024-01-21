CREATE TABLE Employees (
    EmployeeID int NOT NULL,
    LastName nvarchar(255) NOT NULL,
    FirstName nvarchar(255) NOT NULL,
    Title nvarchar(255) NULL,
    TitleOfCourtesy nvarchar(255) NULL,
    BirthDate datetime NULL,
    HireDate datetime NULL,
    Address nvarchar(255) NULL,
    City nvarchar(255) NULL,
    Region nvarchar(255) NULL,
    PostalCode nvarchar(255) NULL,
    Country nvarchar(255) NULL,
    HomePhone nvarchar(255) NULL,
    Extension nvarchar(255) NULL,
    Photo image NULL,
    Notes ntext NULL,
    ReportsTo int NULL,
    PhotoPath nvarchar(255) NULL
);

DECLARE @Class NVARCHAR(MAX) = 'public class Employees{'

DECLARE @ColumnName NVARCHAR(MAX)
DECLARE @ColumnType NVARCHAR(MAX)
DECLARE @ColumnConstraint NVARCHAR(MAX)

DECLARE column_cursor CURSOR FOR
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Employees';

OPEN column_cursor;

FETCH NEXT FROM column_cursor INTO @ColumnName, @ColumnType, @ColumnConstraint;

WHILE @@FETCH_STATUS = 0
BEGIN
    
	SET @Class = CONCAT(@Class, 
        IIF(@ColumnConstraint = 'NO', '[Required(ErrorMessage = "The '+@ColumnName+' is required")] ', '')
    );

    SET @Class = CONCAT(@Class, 
        IIF(@ColumnType = 'nvarchar', '[MaxLength(255)] ', '')
    );

    SET @Class = CONCAT(@Class, 'public ');

	SET @Class = CONCAT(@Class, 
    CASE 
        WHEN @ColumnType = 'int' THEN 'int '
		WHEN @ColumnType = 'datetime' THEN 'DateTime '
		WHEN @ColumnType = 'image' THEN 'byte[] '
		WHEN @ColumnType = 'ntext' THEN 'string '
		WHEN @ColumnType = 'nvarchar' THEN 'string '
    END
    );
    SET @Class = CONCAT(@Class, @ColumnName + '{ get; set; } ');

    --PRINT 'columnName: ' + @ColumnName + ', columnType: ' + @ColumnType + ', columnConstraint: ' + @ColumnConstraint;
    FETCH NEXT FROM column_cursor INTO @ColumnName, @ColumnType, @ColumnConstraint;
END
SET @Class = CONCAT(@Class,'}');
PRINT @Class;
CLOSE column_cursor;
DEALLOCATE column_cursor;


