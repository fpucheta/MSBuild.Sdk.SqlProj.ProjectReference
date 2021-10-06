CREATE VIEW [dbo].[UsersView]
	AS SELECT * FROM [$(SourceDatabase)].[dbo].[Users]
