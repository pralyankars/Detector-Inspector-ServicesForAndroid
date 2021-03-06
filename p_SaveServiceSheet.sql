
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[p_SaveServiceSheet] @BookingId int,
@TechnicianId int,
@Notes nvarchar(max),
@ElectricalNotes nvarchar(max),
@IsElectricianRequired bit,
@HasProblem bit,
@ProblemNotes nvarchar(max),
@IsCardLeft bit,
@HasSignature bit,
@IsElectrical bit,
@OldserviceSheetid int,
@PropertyInfoId int,
@ServiceSheetID int OUTPUT

AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @PropInfoId int
	DECLARE @UserId uniqueidentifier
	DECLARE @IsCompleted bit
	--IsElectrical is Always False
	SET @IsElectrical = 0
	SELECT
		@UserId = UserId
	FROM UserProfile
	WHERE TechnicianId = @TechnicianId

	SELECT
		@IsCompleted = IsAutoApproved
	FROM Technician
	WHERE TechnicianId = @TechnicianId
	--update ServiceSheetItem set IsDeleted = 1 where serviceSheetid =  @OldserviceSheetid      
	UPDATE Detector
	SET IsDeleted = 1
	WHERE PropertyInfoId = @PropertyInfoId


	IF EXISTS (SELECT
			*
		FROM ServiceSheet
		WHERE BookingId = @BookingId) --and CONVERT(VARCHAR(11),CreatedUtcDate,106) = CONVERT(VARCHAR(11),GETDATE(),106)              
	BEGIN

		UPDATE [ServiceSheet]
		SET	[BookingId] = @BookingId,
			[TechnicianId] = @TechnicianId,
			[Date] = GETDATE(),
			[Notes] = @Notes,
			[ElectricalNotes] = @ElectricalNotes,
			[IsElectricianRequired] = @IsElectricianRequired,
			[HasProblem] = @HasProblem,
			[ProblemNotes] = @ProblemNotes,
			[Discount] = '0.0000',
			[IsCompleted] = @IsCompleted,
			[IsCardLeft] = @IsCardLeft,
			[HasSignature] = @HasSignature,
			[IsElectrical] = @IsElectrical,
			[IsDeleted] = 0,
			[CreatedByUserId] = @UserId,
			[CreatedUtcDate] = GETDATE()
		WHERE BookingId = @BookingId --and CONVERT(VARCHAR(11),CreatedUtcDate,106) = CONVERT(VARCHAR(11),GETDATE(),106)              

		SET @ServiceSheetID = (SELECT TOP 1
			ServiceSheetId
		FROM ServiceSheet
		WHERE BookingId = @BookingId
		ORDER BY ServiceSheetId DESC) --and CONVERT(VARCHAR(11),CreatedUtcDate,106) = CONVERT(VARCHAR(11),GETDATE(),106)
		UPDATE ServiceSheetItem
		SET IsDeleted = 1
		WHERE ServiceSheetId = @ServiceSheetID


		SET @PropInfoId = (SELECT
			PropertyInfoId
		FROM Booking
		WHERE BookingId = @BookingId)
		IF @IsCompleted = 1
		BEGIN
			EXEC Sp_UpdatePropertyStatus	@PropInfoId,
											@BookingId
		END
		RETURN @ServiceSheetID
	END
	ELSE
	BEGIN
		INSERT INTO [ServiceSheet] ([BookingId], [TechnicianId], [Date], [Notes], [ElectricalNotes], [IsElectricianRequired],
		[HasProblem], [ProblemNotes], [Discount], [IsCompleted], [IsCardLeft], [HasSignature], [IsElectrical],
		[IsDeleted], [CreatedByUserId], [CreatedUtcDate])
			VALUES (@BookingId, @TechnicianId, GETDATE(), @Notes, @ElectricalNotes, @IsElectricianRequired, @HasProblem, @ProblemNotes, '0.0000', @IsCompleted, @IsCardLeft, @HasSignature, @IsElectrical, 0, @UserId, GETDATE())

		SET @ServiceSheetID = SCOPE_IDENTITY()
		UPDATE ServiceSheetItem
		SET IsDeleted = 1
		WHERE ServiceSheetId = @ServiceSheetID


		SET @PropInfoId = (SELECT
			PropertyInfoId
		FROM Booking
		WHERE BookingId = @BookingId)
		IF @IsCompleted = 1
		BEGIN
			EXEC Sp_UpdatePropertyStatus	@PropInfoId,
											@BookingId
		END
		RETURN (@ServiceSheetID)
	END

	PRINT (@PropInfoId)
END

	SET QUOTED_IDENTIFIER ON
	SET ANSI_NULLS ON

GO
