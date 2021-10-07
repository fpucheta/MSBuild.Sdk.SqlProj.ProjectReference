CREATE VIEW [dbo].[UsersView]
	AS SELECT top 100 * FROM [$(SourceDatabase)].[dbo].[Users]
