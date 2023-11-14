USE [DevOps_Testing]
GO
/****** Object:  StoredProcedure [dbo].[AutoReport]    Script Date: 14-11-2023 20:11:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE procedure [dbo].[AutoReport]
@opt as int=1,
@RptHdrIDs varchar(1000)='1,3,4,5,6,8,9,10,11,12,13'
as

begin

if @opt=1
begin

	Select ARH.cAuto_Report_Name,ARH.cAuto_Report_Desc,ARM.cAR_MenuField_Name,ARM.cAR_MenuField_Object_Name,
	cAR_MenuField_Object_Property,ARSD.cAuto_Report_MenuField_Values,ARM.iMenuField_Action,ARM.iIsMenu_Or_Field, 
	ARM.iMenu_Level,ARD.iSort_Order,ARH.cExport_FileName, ARC.cAuto_Report_Category, ARH.iAuto_Report_Hdr_Id,
	ARS.iAuto_Report_Schedule_Id,ARSD.iAuto_Report_Schedule_Dtl_Id
	from Auto_Report_Schedule ARS
	Inner Join Auto_Report_Hdr ARH ON ARH.iAuto_Report_Hdr_Id=ARS.iAuto_Report_Hdr_Id
	Inner Join Auto_Report_Dtl ARD On ARH.iAuto_Report_Hdr_Id=ARD.iAuto_Report_Hdr_Id
	Inner Join Auto_Report_Schedule_Dtl ARSD ON ARSD.iAuto_Report_Schedule_Id=ARS.iAuto_Report_Schedule_Id and ARD.iAuto_Report_Dtl_id=ARSD.iAuto_Report_Dtl_id
	Inner Join Auto_Report_MenuField ARM On ARM.iAuto_Report_MenuField_id=ARD.iAuto_Report_MenuField_id
	Inner Join Auto_Report_Category ARC On ARC.iAuto_Report_Category_id=ARH.iAuto_Report_Category_id
	Where ARH.bActive=1 and ARD.bActive=1 and ARM.bActive=1 And ARS.bActive=1 And ARSD.bActive=1
	And (@RptHdrIDs='0' Or ARS.iAuto_Report_Schedule_Id in (Select Items from Split(@RptHdrIDs,',')))
	Order by ARH.iAuto_Report_Hdr_Id,ARD.iSort_Order

	--Select ARH.cAuto_Report_Name,ARH.cAuto_Report_Desc,ARM.cAR_MenuField_Name,ARM.cAR_MenuField_Object_Name,
	--cAR_MenuField_Object_Property,ARD.cAuto_Report_MenuField_Values,ARM.iMenuField_Action,ARM.iIsMenu_Or_Field, 
	--ARM.iMenu_Level,ARD.iSort_Order,ARH.cExport_FileName, ARC.cAuto_Report_Category, ARH.iAuto_Report_Hdr_Id
	--from Auto_Report_Hdr ARH
	--Inner Join Auto_Report_Dtl ARD On ARH.iAuto_Report_Hdr_Id=ARD.iAuto_Report_Hdr_Id
	--Inner Join Auto_Report_MenuField ARM On ARM.iAuto_Report_MenuField_id=ARD.iAuto_Report_MenuField_id
	--Inner Join Auto_Report_Category ARC On ARC.iAuto_Report_Category_id=ARH.iAuto_Report_Category_id
	--Where ARH.bActive=1 and ARD.bActive=1 and ARM.bActive=1
	--And (@RptHdrIDs='0' Or ARH.iAuto_Report_Hdr_Id in (Select Items from Split(@RptHdrIDs,',')))
	--Order by ARH.iAuto_Report_Hdr_Id,ARD.iSort_Order

	--select cReport_Url,cReport_User,cReport_Password,
	--case when iIsPDF_Req =1 then 'Y' else 'N' end as iIsPDF_Req,
	--case when iIsExcel_Req =1 then 'Y' else 'N' end as iIsExcel_Req,
	--cReport_Workbook_Type,cRpt_Property,cRpt_Book,cRpr_AccountTree,cReport_Type,cRpt_Period_From,cRpt_Period_To from Auto_Report_Mapping
	--where cReport_User=@UserName and cReport_Password=@Password

end

end
