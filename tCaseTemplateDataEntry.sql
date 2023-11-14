SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


























































































CREATE PROCEDURE [dbo].[tCaseTemplateDataEntry]
@opt as int=null,
@iCompany_id as int= null,
@iDoc_Template_id as int=null,
@Userid as int=null,
@FromDate as varchar(max)='',
@Todate as varchar(max)='',
@status as varchar(max)='',
@companyid as int=0,
@iMast_Status_Rights_Id as int=0,
@PDHId as Int=0,
@RightsOrderId as Int=null,
@statusRightId as Int=null,
@iDoc_Template_Dtl_id as int=null,
@iMast_Status_id as int=null,
@DoctempSubCatReq as Int=null,
@iIsSortOrder_Needed Int=null,
@iIsDocument_Needed Int=null,
@iIsPropManager_Needed Int = Null,
@iProperty_Document_Dtl_id Int=null,
@cCase_No as varchar(50)='',
@PDHId_str nvarchar(max) = null,
@iMast_Tenant_id Int=null,
@iMast_Property_Id Int=null,
@cTenant_Name nvarchar(max) = null,
@cTenant_Code nvarchar(max) = null 

as
begin
	DECLARE @cols AS NVARCHAR(MAX)='',
    @cols1 AS NVARCHAR(MAX)='',
			@query  AS VARCHAR(8000) ,
			@UserRoleType as Int=0

	if @opt=1
	begin
		--select distinct MCI.iCompany_id,MCI.cCompany_Name,DocT.cDoc_Template_Name,DocT.iDoc_Template_id from ASTIL_Admin.dbo.Mast_Company_info MCI left join 
		--Doc_Template DocT on MCI.iCompany_id=DocT.iCompany_id where DocT.bActive=1 and MCI.bActive=1

		select distinct MCI.iCompany_id,MCI.cCompany_Name,isnull(DTC.cTemplate_Category,DocT.cDoc_Template_Name) as cDoc_Template_Name,DocT.iDoc_Template_id,DocT.cDoc_Template_Name as tempname 
		from ASTIL_Admin.dbo.Mast_Company_info MCI
		inner join Doc_Template_Company_Rights DTCR on DTCR.iCompany_id=MCI.iCompany_id
		inner join Doc_Template_User_Rights DTUR on DTUR.iDoc_Template_Company_Rights_ID=DTCR.iDoc_Template_Company_Rights_ID
		inner join Doc_Template DocT on DocT.iDoc_Template_id =DTCR.iDoc_Template_id 
		Inner join Doc_Template_Category DTC on DocT.iDoc_Template_Category_Id =DTC.iDoc_Template_Category_Id 
		where DTC.bActive=1 and DTCR.bactive=1 and DocT.bActive=1 and MCI.bActive=1  and DTUR.bactive=1  and DocT.iTemplate_Type=1 and DTUR.iUser_id=@Userid
	end

	if @opt=2
	begin
		select cField_Type,cField_Disp_Name,cField_Find_Name,iCompany_id,DTD.iDoc_Template_Dtl_id,DTD.cColumn_Def_Value,DTD.iDef_Values_Type,
	    DocT.iIs_Required_Archive,DTD.iValue_Line_No,DocT.iDelete_Days,DocT.iComments_Delete_Days,DocT.bIs_Litigation,isnull(DTD.cDisplay_Desc,'') as  cDisplay_Desc,DTD.iIs_Editable,DTD.cEditable_UserType,DTD.iSort_Order from Doc_Template_Dtl DTD left join 
		Doc_Template DocT on DocT.iDoc_Template_id=DTD.iDoc_Template_id
		where DTD.iDoc_Template_id=@iDoc_Template_id and DTD.bActive=1
		and DocT.bActive=1 order by iSort_Order asc
	end
		if @opt=3
	begin
		--SELECT @cols = @cols + '[' +  cField_Disp_Name + '],'
		--	FROM   (SELECT DISTINCT RTRIM( LTRIM( cField_Disp_Name)) as cField_Disp_Name
		--							--cField_Find_Name
		--			FROM ASTIL_RealServ..Doc_Template DT
		--INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--	AND DTD.bActive = 1
		--LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
		--	AND DTD.bActive = 1 
		----LEFT JOIN ASTIL_RealServ..Property_Document_Dtl PDD ON PDDD.iProperty_Document_Dtl_id = PDD.iProperty_Document_Dtl_id
		----	AND PDDD.bActive = 1
		--left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
		--LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
		--LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--where dt.bActive=1 and DT.iDoc_Template_id=@iDoc_Template_id ) AS TBL1
		--print @cols
		--	SELECT @cols = Stuff(@cols,Len(@cols),
		--								 1,
		--								 '')
		--set @query = 'SELECT  cCompany_Name ,cDoc_Template_Name,cTask_Name,' + @cols + ' from 
		--			(
		--			   select cField_Disp_Name, isnull(cField_Find_Name,'''') as cField_Find_Name,MCI.cCompany_Name, DT.cDoc_Template_Name,isnull(MG.cTask_Name,'''') as cTask_Name
		--FROM ASTIL_RealServ..Doc_Template DT
		--INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--	AND DTD.bActive = 1
		--LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
		--	AND DTD.bActive = 1 
		--left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
		--LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
		--LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--where dt.bActive=1 and DT.iDoc_Template_id='+ cast(@iDoc_Template_id as varchar(50))+'
		--		   ) x
		--		   pivot (max(cField_Find_Name) for         cField_Disp_Name  in (' + @cols + ')
		--			) p '

 
		--print @query

		--exec (@query)
		--Declare @DoctempSubCatReq as Int;
		Create Table #tempDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id int ,iDoc_Template_id Int,iDoc_Template_Dtl_id int,iCompany_id Int, iTo_User_Id Int, iIsVisible Int, bActive Int)  
		Create Table #tempdata(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max),iProperty_Document_Hdr_id int,cColumn_Value nvarchar(max), iSort_Order Int)  
		Create Table #tempclmname(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max), iSort_Order Int) 
      --  Declare @iIsSortOrder_Needed Int, @iIsDocument_Needed Int;

		select @iIsSortOrder_Needed=iIsSortOrder_Needed,@iIsDocument_Needed=iIsDocument_Needed, @iIsPropManager_Needed=iIsPropManager_Needed from Doc_Template_Settings 
		where iDoc_Template_id=@iDoc_Template_id and iCompany_id=@companyid and bActive=1

		if not exists(Select * From Doc_Template_Dtl_Visible Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=@Userid )   
		begin
			insert into #tempDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 
			Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
			Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=@Userid
		End
		Else
		Begin
			insert into #tempDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 
			Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
			Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=0
		End

		insert into #tempdata(cColumn_Name,iProperty_Document_Hdr_id,cColumn_Value,iSort_Order) 
        SELECT  RTRIM( LTRIM( cColumn_Name)) as cColumn_Name,PDDD.iProperty_Document_Hdr_id,cColumn_Value,DTD.iSort_Order
                    FROM ASTIL_RealServ..Doc_Template DT
        INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id and DTD.bActive=1
        LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
        left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id  and PDH.bActive=1  
		Left Join #tempDoc_Template_Dtl_Visible DTV ON DTD.iDoc_Template_Dtl_id=DTV.iDoc_Template_Dtl_id and DTV.iCompany_id=PDH.iCompany_id and DTV.bActive=1 and DTV.iIsVisible=1
        LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
        LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=PDH.iCompany_id
		where PDH.bActive=1 and DT.iDoc_Template_id=@iDoc_Template_id --and PDH.iCompany_id=@companyid
        and (isnull(@FromDate,'')='' or convert(varchar(10),PDH.dProperty_Doc_dt,121) between convert(varchar(10),@FromDate,121)  And  convert(varchar(10), @Todate,121) )
        and (isnull(@companyid,'') ='' or PDH.iCompany_id= @companyid) and (isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))
        Order by DTD.iSort_Order

		Insert into #tempclmname(cColumn_Name,iSort_Order)
		select distinct cColumn_Name,iSort_Order from #tempdata order by iSort_Order option (force order)
		--Select * from #tempclmname
		set @cols=(Select stuff((select '[' + Convert(varchar(max),cColumn_Name) + '],' from #tempclmname FOR XML PATH('')),1,0,''))
        set @cols= LEFT(@cols, LEN(@cols) - 1)     
        print @cols
        drop table #tempdata
		drop table #tempDoc_Template_Dtl_Visible
		
		Select @UserRoleType=MU.bSuperUser from ASTIL_Admin.dbo.Mast_Users MU Where iUser_id=@Userid
		Select @DoctempSubCatReq=DT.iIsSubCategory_Req FROM ASTIL_RealServ..Doc_Template DT where DT.iDoc_Template_id=@iDoc_Template_id 
		
		set @query = 'SELECT   cCompany_Name ,cDoc_Template_Name,PropertyId, PropertyName, cMast_Status,SortOrder,' + Case @DoctempSubCatReq When 1 then '[Sub Category],' else '' End + 'cCase_No,PDHId,MastStatusId,MastPropertyid,' + @cols + ',
					' + Case @iIsDocument_Needed When 1 then 'cScan_Note_Name,' else '' End + ''  + Case @iIsPropManager_Needed When 1 then '[Property Manager],' else '' End + 'CreateOn,DocDate,UserName,cProperty_Alais_Name,UserRoleType from 
                    (
                       select cColumn_Name ,cast(isnull(cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name, 
					   MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, ME.cEmpName as UserName,PDH.cScan_Note_Name,DT.cProperty_Alais_Name,
					   ' + Case @iIsSortOrder_Needed When 1 then 'FORMAT(isnull(MSR.iSort_Order,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status' else 'MS.cMast_Status' End + ' as cMast_Status, 
					   PDH.cCase_No, Format(PDH.dUpdated_dt,''MM/dd/yyyy hh:mm tt'') as DocDate ,
					   PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,MP.iMast_Property_Id as MastPropertyid,convert(varchar(22),PDH.dUpdated_dt,121) as UpdateDt,
					  Format(PDH.dCreate_dt,''MM/dd/yyyy hh:mm tt'') as CreateOn,isnull(Manager,'''') as [Property Manager],
					   MP.cProperty_Id as PropertyId, MSC.cSub_Category as [Sub Category],FORMAT(isnull(MSR.iSort_Order_Grid,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status as SortOrder, ' + Convert(Varchar(10),@UserRoleType) + ' as UserRoleType
        FROM ASTIL_RealServ..Doc_Template DT
        INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
        INNER JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
        INNER JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
		INNER JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=isnull(PDH.iUpd_User_id,PDH.iUser_id)
		Left Join ASTIL_Admin.dbo.Mast_Employee ME ON ME.iEmp_id=MU.iEmp_id
		left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
		left join ASTIL_RealServ..PropertyManager_view MPM on MPM.iMast_Property_Id=MP.iMast_Property_Id
        INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=PDH.iCompany_id
		INNER join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus and MS.bActive=1
		Left Join ASTIL_RealServ..Mast_Status_Rights MSR On PDH.bStatus=MSR.iMast_Status_id And PDH.iCompany_id=MSR.iCompany_id And PDH.iDoc_Template_id=MSR.iDoc_Template_id and MSR.bActive=1
		Left Join ASTIL_Admin.dbo.Mast_Company_info MCIR On MCIR.iCompany_id=MSR.iCompany_id_Res
        Left Join Mast_Sub_Category MSC ON MSC.iMast_Sub_Category_Id=PDH.iMast_Sub_Category_Id
		where PDH.bActive=1  and PDH.iDoc_Template_id='+ cast(@iDoc_Template_id as varchar(50))+' and (isnull(''' +  convert(varchar(10),@FromDate,121) +''' ,'''')='''' or  (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' +  convert(varchar(10),@FromDate,121) +''' And  ''' +convert(varchar(10), @Todate,121) +''' ))
        and ('+ cast(@companyid as varchar)+' = 0 OR PDH.iCompany_id= '+ cast(@companyid as varchar)+') and ('+ cast(@companyid as varchar)+'=0 or  (isnull('''+ CAST(@status as varchar)+''','''')='''' or PDH.bStatus in(SELECT Items FROM  Split('''+ CAST(@status as varchar)+''','',''))))
        
        and PDH.bStatus not in (Select Distinct MSS.iMast_Status_id  From Mast_Status_View_Restrict MVR Inner Join Mast_Status_Rights MSS ON MSS.iMast_Status_Rights_Id=MVR.iMast_Status_Rights_Id inner join ASTIL_Admin..Mast_Users MU on MVR.iViewRestrict_Role_Type_id=MU.bSuperUser Where MVR.bActive=1  and MSS.bActive=1 and MU.iUser_id='+ cast(@Userid as varchar)+ ' and MSS.iDoc_Template_id=DT.iDoc_Template_id)
		) x
          pivot (max(cColumn_Value) for         cColumn_Name  in (' + @cols + ')
         ) p Where iDoc_Template_id='+ cast(@iDoc_Template_id as varchar(50))+' Order by CreateOn asc'
 
       print @query
 
       exec (@query)
	end
	if @opt=4
	begin
			select iMast_Property_Id as id, cProperty_Name as [name] from Mast_Property where bActive=1  
	end
	if @opt=5
	begin
		select MS.iMast_Status_id as id, MS.cMast_Status as [name],MSR.iMast_Status_id_Def,MSR.iCompany_id from Mast_Status MS 
		INNER JOIN  Mast_Status_Rights MSR ON MSR.iMast_Status_id=MS.iMast_Status_id
		where MS.bActive=1 and MSR.bActive=1 and MSR.iCompany_id=@companyid
	end
	if @opt=6
	begin
		---select 
		------iMast_Status_Rights_Id,MSR.iCompany_id,MSR.iDoc_Template_id,MSR.iMast_Status_id as id,iMast_Status_id_Def,MSR.iSort_Order
		---,cCompany_Name,cMast_Status as [name],cDoc_Template_Name 
		---from Mast_Status_Rights MSR
		---inner join ASTIL_Admin..Mast_Company_info MCI on MCI.iCompany_id=MSR.iCompany_id
		---inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
		--inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id
		--where MSR.bActive=1 AND MCI.bActive=1 AND MS.bActive=1 and DT.bActive=1  and MSR.iCompany_id=@companyid and MSR.iDoc_Template_id=@iDoc_Template_id
		--order by cMast_Status asc

		select top 1 MSR.iMast_Status_id as id,FORMAT(MSR.iSort_Order,'0#') + '. ' + MCI.cRes_ShortName + ' - ' + MS.cStatus_ShortName [name],MS.cMast_Status,MSR.iIs_Comment_Req
		from Mast_Status_Rights MSR
		inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
		inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id
		Inner Join ASTIL_Admin.dbo.Mast_Company_info MCI On MCI.iCompany_id=MSR.iCompany_id_Res
		where MSR.bActive=1  AND MS.bActive=1 and DT.bActive=1
		and MSR.iCompany_id=@Companyid and MSR.iDoc_Template_id=@iDoc_Template_id   
		Order by MSR.iSort_Order
	end
	if @opt=7
	begin
		select iMast_Property_Id as id, cProperty_Id+' - '+ cProperty_Name as [name] from Mast_Property where bActive=1 and iCompany_id=@companyid		
		order by cProperty_Name 
	end
		if @opt=8
	begin
	--select cMast_Status,iMast_Status_Rights_Order_Id,MSRO.iMast_Status_id,MSRO.iSort_Order from Mast_Status_Rights MSR 
 --   INNER JOIN Mast_Status_Rights_Order MSRO on MSRO.iMast_Status_Rights_Id=MSR.iMast_Status_Rights_Id
 --   inner join Mast_Status MS on MS.iMast_Status_id=MSRO.iMast_Status_id
 --   where MSR.bactive=1 and MSRO.bActive=1 and MSRO.iMast_Status_Rights_Id=@iMast_Status_Rights_Id
 select cMast_Status,iMast_Status_Rights_Order_Id,MSRO.iMast_Status_id,MSRO.iSort_Order,iMast_Status_id_Def,MSR.iMast_Status_id from Mast_Status_Rights MSR 
    INNER JOIN Mast_Status_Rights_Order MSRO on MSRO.iMast_Status_Rights_Id=MSR.iMast_Status_Rights_Id
    inner join Mast_Status MS on MS.iMast_Status_id=MSRO.iMast_Status_id
    where MSR.bactive=1 and MSRO.bActive=1 and MSR.iMast_Status_id=@RightsOrderId and MSRO.iMast_Status_id=@statusRightId
	end
if @opt=9
	begin

	declare @hdrId int = null
		--Create Table #tempdatapdh(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max),iProperty_Document_Hdr_id int,cColumn_Value nvarchar(max), iSort_Order Int)                
		--Create Table #tempclmnamepdh(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max), iSort_Order Int) 

  --      insert into #tempdatapdh(cColumn_Name,iProperty_Document_Hdr_id,cColumn_Value,iSort_Order) 
  --      SELECT  RTRIM( LTRIM( cColumn_Name)) as cColumn_Name,PDDD.iProperty_Document_Hdr_id,cColumn_Value,DTD.iSort_Order
  --                  FROM ASTIL_RealServ..Doc_Template DT
  --      INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
  --          AND DTD.bActive = 1
  --      LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
  --          AND PDDD.bActive = 1 
  --      left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
  --      LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
  --      LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
  --      where dt.bActive=1 and PDH.iProperty_Document_Hdr_id=@PDHId
  --      and (isnull(@FromDate,'')='' or convert(varchar(10),PDH.dProperty_Doc_dt,121) between convert(varchar(10),@FromDate,121)  And  convert(varchar(10), @Todate,121) )
  --      and (isnull(@companyid,'') ='' or PDH.iCompany_id= @companyid) and (isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))
  --      Order by DTD.iSort_Order

		--Insert into #tempclmnamepdh(cColumn_Name,iSort_Order)
		--select distinct cColumn_Name,iSort_Order from #tempdatapdh order by iSort_Order option (force order)

  --      set @cols=(Select stuff((select distinct  '[' + Convert(varchar(max),cColumn_Name) + '],' from #tempclmnamepdh FOR XML PATH('')),1,0,''))
  --      set @cols= LEFT(@cols, LEN(@cols) - 1)     
  --      print @cols
  --      drop table #tempdatapdh
 
		--set @query = 'SELECT  cCompany_Name ,cDoc_Template_Name,cScan_Note_Name, PropertyName, cMast_Status, cCase_No, DocDate,PDHId,MastStatusId,CompId,PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,iDoc_Template_Dtl_id,iValue_Line_No,cColumn_Name,cColumn_Value,iDef_Values_Type,cColumn_ID,cRemarks,iMast_Sub_Category_Id from 
  --                  (
  --                  select PDDD.cColumn_Name ,cast(isnull(PDDD.cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name, 
		--			MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, MU.cLogin as UserName,PDH.cScan_Note_Name,MS.cMast_Status, PDH.cCase_No, convert(varchar(10),PDH.dProperty_Doc_dt,101)+ '' '' + CONVERT(VARCHAR(5), PDH.dProperty_Doc_dt, 108) as DocDate ,
		--			PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,PDH.iCompany_id as CompId,PDH.iMast_Property_Id as PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,PDH.iMast_Sub_Category_Id,
		--			PDDD.iDoc_Template_Dtl_id,DTD.iValue_Line_No,DTD.iDef_Values_Type,PDDD.cColumn_ID,PDH.cRemarks,DTD.iSort_Order as ClmSortOrder
		--			FROM ASTIL_RealServ..Doc_Template DT
		--			INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--			INNER JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
		--				AND PDDD.bActive = 1 
		--			INNER JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
		--			INNER JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=PDH.iUser_id
		--			left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
		--			INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--			INNER join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus
		--			where dt.bActive=1 
		--			and (isnull(''' +  convert(varchar(10),@FromDate,121) +''' ,'''')='''' or  (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' +  convert(varchar(10),@FromDate,121) +''' And  ''' +convert(varchar(10), @Todate,121) +''' ))
		--			and ('+ cast(@companyid as varchar)+' = 0 OR PDH.iCompany_id= '+ cast(@companyid as varchar)+') and ('+ cast(@companyid as varchar)+')=0 or  (isnull('''+ CAST(@status as varchar)+''','''')='''' or PDH.bStatus in(SELECT Items FROM  Split('''+ CAST(@status as varchar)+''','','')))
		--			Union 
		--			select PDDD.cColumn_Name ,cast(isnull(PDDD.cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name, 
		--			MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, MU.cLogin as UserName,PDH.cScan_Note_Name,MS.cMast_Status, PDH.cCase_No, convert(varchar(10),PDH.dProperty_Doc_dt,101)+ '' '' + CONVERT(VARCHAR(5), PDH.dProperty_Doc_dt, 108) as DocDate ,
		--			PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,PDH.iCompany_id as CompId,PDH.iMast_Property_Id as PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,PDH.iMast_Sub_Category_Id,
		--			PDDD.iDoc_Template_Dtl_id,DTD.iValue_Line_No,DTD.iDef_Values_Type,PDDD.cColumn_ID,PDH.cRemarks,DTD.iSort_Order as ClmSortOrder
		--			FROM ASTIL_RealServ..Doc_Template DT
		--			INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--			Left JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
		--				AND PDDD.bActive = 1 
		--			Left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
		--			Left JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=PDH.iUser_id
		--			left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
		--			INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--			Left join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus
		--			where dt.bActive=1 And  DTD.iDoc_Template_Dtl_id not in (Select iDoc_Template_Dtl_id from Doc_Template_Dtl Where PDH.iDoc_Template_id=Doc_Template_Dtl.iDoc_Template_id)
		--			and (isnull(''' +  convert(varchar(10),@FromDate,121) +''' ,'''')='''' or  (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' +  convert(varchar(10),@FromDate,121) +''' And  ''' +convert(varchar(10), @Todate,121) +''' ))
		--			and ('+ cast(@companyid as varchar)+' = 0 OR PDH.iCompany_id= '+ cast(@companyid as varchar)+') and ('+ cast(@companyid as varchar)+')=0 or  (isnull('''+ CAST(@status as varchar)+''','''')='''' or PDH.bStatus in(SELECT Items FROM  Split('''+ CAST(@status as varchar)+''','','')))
                
		--)  as A Where PDHId='+ cast(@PDHId as varchar(50))+' Order by ClmSortOrder'
		--set @query='select * from (
		--			select PDDD.cColumn_Name
		--			,cast(isnull(PDDD.cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name,
		--			MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, MU.cLogin as UserName,PDH.cScan_Note_Name,MS.cMast_Status, PDH.cCase_No, 
		--			convert(varchar(10),PDH.dProperty_Doc_dt,101)+ '''' + CONVERT(VARCHAR(5), PDH.dProperty_Doc_dt, 108) as DocDate ,
		--			PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,PDH.iCompany_id as CompId,PDH.iMast_Property_Id as PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,PDH.iMast_Sub_Category_Id,
		--			PDDD.iDoc_Template_Dtl_id,DTD.iValue_Line_No,DTD.iDef_Values_Type,PDDD.cColumn_ID,PDH.cRemarks,DTD.iSort_Order as ClmSortOrder
		--			FROM ASTIL_RealServ..Doc_Template DT
		--			INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--			Left JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
		--			AND PDDD.bActive = 1
		--			Left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id
		--			Left JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=PDH.iUser_id
		--			left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
		--			INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--			Left join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus
		--			where dt.bActive=1 and DTD.bActive=1 and PDH.bActive=1 And PDH.iProperty_Document_Hdr_id ='+ convert(varchar, @PDHId) +'
		--			union
		--			select dtd.cField_Disp_Name as cColumn_Name,'''' as cColumn_Value , DT.cDoc_Template_Name, MCI.cCompany_Name, ''''as PropertyName,DT.cDoc_Template_Name as ProcessName,
		--			'''' as UserName,'''' cScan_Note_Name,'''' cMast_Status, '''' cCase_No,'''' as DocDate,
		--			0 as iProperty_Document_Hdr_id,DT.iDoc_Template_id,'+ convert(varchar, @PDHId) +' as PDHId,0 as MastStatusId,0 as CompId,0 as PropertyId,
		--			cField_Type,cField_Disp_Name,cField_Find_Name,0 iMast_Sub_Category_Id,
		--			DTD.iDoc_Template_Dtl_id,DTD.iValue_Line_No,DTD.iDef_Values_Type,0 cColumn_ID,'''' cRemarks,DTD.iSort_Order as ClmSortOrder
		--			FROM ASTIL_RealServ..Doc_Template_Dtl DTD
		--			inner join ASTIL_RealServ..Doc_Template DT ON DTD.iDoc_Template_id = DT.iDoc_Template_id
		--			INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
		--			where DTD.iDoc_Template_id in(
		--			 select distinct DTD.iDoc_Template_id  from ASTIL_RealServ..Property_Document_Hdr  PDH
		--			 inner join  ASTIL_RealServ..Property_Document_Hdr_Desc PDDD on  PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id and DTD.bActive=1 
		--			 INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id AND PDDD.bActive = 1
		--			 where PDH.iProperty_Document_Hdr_id ='+ convert(varchar, @PDHId) +')
		--			 and DTD.iDoc_Template_Dtl_id not in(
		--			  select distinct DTD.iDoc_Template_Dtl_id  from ASTIL_RealServ..Property_Document_Hdr  PDH
		--			 inner join  ASTIL_RealServ..Property_Document_Hdr_Desc PDDD on  PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id and DTD.bActive=1 
		--			 INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id AND PDDD.bActive = 1
		--			 where  PDH.bActive=1 and PDH.iProperty_Document_Hdr_id ='+ convert(varchar, @PDHId) +')
		--			  ) A order by  ClmSortOrder'
	 set @query = 'SELECT cCompany_Name ,cDoc_Template_Name,cScan_Note_Name, PropertyName, cMast_Status, cCase_No, DocDate,PDHId,MastStatusId,CompId,PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,iDoc_Template_Dtl_id,iValue_Line_No,cColumn_Name,cColumn_Value,iDef_Values_Type,cColumn_ID,cRemarks,iMast_Tenant_id,iMast_Sub_Category_Id,bIs_Litigation,iDelete_Days,iIs_Required_Archive,iComments_Delete_Days,cEditable_UserType,iIs_Editable,cDisplay_Desc from
	(
	select PDDD.cColumn_Name ,cast(isnull(PDDD.cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name,
	MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, MU.cLogin as UserName,PDH.cScan_Note_Name,MS.cMast_Status, PDH.cCase_No, convert(varchar(10),PDH.dProperty_Doc_dt,101)+ '' '' + CONVERT(VARCHAR(5), PDH.dProperty_Doc_dt, 108) as DocDate ,
	PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,PDH.iCompany_id as CompId,PDH.iMast_Property_Id as PropertyId,cField_Type,cField_Disp_Name,cField_Find_Name,PDH.iMast_Sub_Category_Id, PDH.iMast_Tenant_id,
	PDDD.iDoc_Template_Dtl_id,DTD.iValue_Line_No,DTD.iDef_Values_Type,PDDD.cColumn_ID,PDH.cRemarks,DTD.iSort_Order as ClmSortOrder,PDH.bIs_Litigation,PDH.iDelete_Days,DT.iIs_Required_Archive,PDH.iComments_Delete_Days,DTD.cEditable_UserType,DTD.iIs_Editable,cast(isnull(DTD.cDisplay_Desc,'''') as varchar(max)) as cDisplay_Desc
	FROM ASTIL_RealServ..Doc_Template DT
	INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
	INNER JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id
	AND PDDD.bActive = 1
	INNER JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id
	INNER JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=PDH.iUser_id
	left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
	INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
	INNER join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus

	where dt.bActive=1
	and (isnull(''' + convert(varchar(10),@FromDate,121) +''' ,'''')='''' or (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' + convert(varchar(10),@FromDate,121) +''' And ''' +convert(varchar(10), @Todate,121) +''' ))
	and ('+ cast(@companyid as varchar)+' = 0 OR PDH.iCompany_id= '+ cast(@companyid as varchar)+') and ('+ cast(@companyid as varchar)+')=0 or (isnull('''+ CAST(@status as varchar)+''','''')='''' or PDH.bStatus in(SELECT Items FROM Split('''+ CAST(@status as varchar)+''','','')))
	) as A Where PDHId='+ cast(@PDHId as varchar(50))+' Order by ClmSortOrder'

				print @query
 
	     
 
       exec (@query)
	end
	if @opt=10
	begin
		Declare @strQry as Varchar(max)
		Select @strQry=cColumn_Def_Value from Doc_Template_Dtl Where iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id
		If Len(@strQry) > 0
		Begin
			Exec(@strQry)
		End
		Else
		Begin
			--Select cValues,cLabel_Name,iDoc_Template_Dtl_Values_id from Doc_Template_Dtl_Values Where iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id
			Select cValues,cLabel_Name,iDoc_Template_Dtl_Values_id,iDoc_Template_Dtl_id from Doc_Template_Dtl_Values Where iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id and bActive=1

			


		End
	end
	if @opt=11
	begin
	select distinct top 1 MSR.iMast_Status_id as id,cMast_Status [name]
        from Mast_Status_Rights MSR
        inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
        inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id
        where MSR.bActive=1  AND MS.bActive=1 and DT.bActive=1
        and MSR.iCompany_id=@Companyid and MSR.iDoc_Template_id=@iDoc_Template_id   
	end
	if @opt=12
	begin
		select distinct  ISNULL(MCI.iCompany_id,'') as iCompany_id,
		DT.iDoc_Template_id as id,cDoc_Template_Name as [name],MCI.cCompany_Name
		from Doc_Template DT
		INNER join Doc_Template_Company_Rights DTCR on DTCR.iDoc_Template_id_Def=DT.iDoc_Template_id and DTCR.bActive=1 
		inner join Doc_Template_User_Rights DTUR on DTUR.iDoc_Template_Company_Rights_ID=DTCR.iDoc_Template_Company_Rights_ID and DTUR.bActive=1
		INNER JOIN ASTIL_Admin..Mast_Company_info MCI on MCI.iCompany_id=DTCR.iCompany_id
		where DT.bActive=1 and DTCR.iCompany_id=@Companyid and DTUR.iUser_id=@Userid
		--and DTCR.iCompany_id in(SELECT iCompany_id FROM ASTIL_Admin..Mast_Company_User_Rights UR Where UR.bActive=1 and UR.iComp_User_Id =@Userid)
		order by  DT.iDoc_Template_id asc

	 --   select distinct  ISNULL(MCI.iCompany_id,'') as iCompany_id,
		--DocT.iDoc_Template_id as id,cDoc_Template_Name as [name],MCI.cCompany_Name
		--from ASTIL_Admin.dbo.Mast_Company_info MCI
		--inner join Doc_Template_Company_Rights DTCR on DTCR.iCompany_id=MCI.iCompany_id
		--inner join Doc_Template_User_Rights DTUR on DTUR.iDoc_Template_Company_Rights_ID=DTCR.iDoc_Template_Company_Rights_ID
		--inner join Doc_Template DocT on DocT.iDoc_Template_id =DTCR.iDoc_Template_id 		
		--where  DTCR.bactive=1 and DocT.bActive=1 and MCI.bActive=1  and DTUR.bactive=1 And DocT.iTemplate_Type=1 and DTCR.iCompany_id=@Companyid and DTUR.iUser_id=@Userid
		--and  DTCR.iCompany_id in(SELECT iCompany_id FROM ASTIL_Admin..Mast_Company_User_Rights UR Where UR.bActive=1 and UR.iComp_User_Id =@Userid and iCompany_id=@Companyid)
		--order by  DocT.iDoc_Template_id desc

	end
	if @opt=13
	begin
		select cMast_Status,iMast_Status_id,cStatus_ShortName from Mast_Status where iMast_Status_id=@iMast_Status_id and bActive=1
	end
	if @opt=14
	begin
	
	select PDH.cCase_No,PDH.iCompany_id,DT.iDoc_Template_id,DT.cDoc_Template_Name,MCI.cCompany_Name,MCI.iCompany_id,DTC.cTemplate_Category,PDH.iMast_Sub_Category_Id from Property_Document_Hdr PDH 
	inner join Doc_Template DT on DT.iDoc_Template_id=PDH.iDoc_Template_id
	inner join ASTIL_Admin..Mast_Company_info MCI on MCI.iCompany_id=PDH.iCompany_id
	inner join Doc_Template_Category DTC on DTC.iDoc_Template_Category_Id=DT.iDoc_Template_Category_Id
	where iProperty_Document_Hdr_id=@PDHId and DT.bActive=1
	end
		if @opt=15
	begin
		

		--exec (@query)
		
			Create Table #tempCmtDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id int ,iDoc_Template_id Int,iDoc_Template_Dtl_id int,iCompany_id Int, iTo_User_Id Int, iIsVisible Int, bActive Int)  
	Create Table #tempCmtdata(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max),iProperty_Document_Hdr_id int,cColumn_Value nvarchar(max), iSort_Order Int)  
	Create Table #tempCmtclmname(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max), iSort_Order Int) 


	select @iIsSortOrder_Needed=iIsSortOrder_Needed,@iIsDocument_Needed=iIsDocument_Needed from Doc_Template_Settings 
	where iDoc_Template_id=@iDoc_Template_id and iCompany_id=@companyid and bActive=1

	if not exists(Select * From Doc_Template_Dtl_Visible Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=@Userid )   
	begin
		insert into #tempCmtDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 
		Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
		Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=@Userid
	End
	Else
	Begin
		insert into #tempCmtDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 
		Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
		Where iCompany_id=@Companyid and iDoc_Template_id=@iDoc_Template_id and iTo_User_Id=0
	End

	insert into #tempCmtdata(cColumn_Name,iProperty_Document_Hdr_id,cColumn_Value,iSort_Order) 
 SELECT  RTRIM( LTRIM( cColumn_Name)) as cColumn_Name,PDDD.iProperty_Document_Hdr_id,cColumn_Value,DTD.iSort_Order
             FROM ASTIL_RealServ..Doc_Template DT
 INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
 LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
 left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
	Left Join #tempCmtDoc_Template_Dtl_Visible DTV ON DTD.iDoc_Template_Dtl_id=DTV.iDoc_Template_Dtl_id and DTV.iCompany_id=PDH.iCompany_id and DTV.bActive=1 and DTV.iIsVisible=1
 LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
 LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
	where DT.iDoc_Template_id=@iDoc_Template_id --and PDH.iCompany_id=@companyid
 and (isnull(@FromDate,'')='' or convert(varchar(10),PDH.dProperty_Doc_dt,121) between convert(varchar(10),@FromDate,121)  And  convert(varchar(10), @Todate,121) )
 and (isnull(@companyid,'') ='' or PDH.iCompany_id= @companyid) and (isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))
 Order by DTD.iSort_Order

	Insert into #tempCmtclmname(cColumn_Name,iSort_Order)
	select distinct cColumn_Name,iSort_Order from #tempCmtdata order by iSort_Order option (force order)
	--Select * from ##tempCmtclmname
	set @cols=(Select stuff((select '[' + Convert(varchar(max),cColumn_Name) + '],' from #tempCmtclmname FOR XML PATH('')),1,0,''))
 set @cols= LEFT(@cols, LEN(@cols) - 1)     
 print @cols
 drop table #tempCmtdata
	drop table #tempCmtDoc_Template_Dtl_Visible
	
	Select @DoctempSubCatReq=DT.iIsSubCategory_Req FROM ASTIL_RealServ..Doc_Template DT where DT.iDoc_Template_id=@iDoc_Template_id 
	
	set @query = 'SELECT   cCompany_Name ,cDoc_Template_Name,PropertyId, PropertyName, cMast_Status,SortOrder,' + Case @DoctempSubCatReq When 1 then '[Sub Category],' else '' End + 'cCase_No,PDHId,MastStatusId,MastPropertyid,' + @cols + ',
				' + Case @iIsDocument_Needed When 1 then 'cScan_Note_Name,' else '' End + 'CreateOn,DocDate,UserName,Comments, cBBForms_Data_id as mDataReturnId from 
             (
                select cColumn_Name ,cast(isnull(cColumn_Value,'''') as varchar(max)) as cColumn_Value,DT.cDoc_Template_Name,MCI.cCompany_Name, 
				   MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, ME.cEmpName as UserName,PDH.cScan_Note_Name,
				   ' + Case @iIsSortOrder_Needed When 1 then 'FORMAT(isnull(MSR.iSort_Order,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status' else 'MS.cMast_Status' End + ' as cMast_Status, 
				   PDH.cCase_No,Format(PDH.dUpdated_dt,''MM/dd/yyyy hh:mm tt'') as DocDate,
				   PDDD.iProperty_Document_Hdr_id,DT.iDoc_Template_id,PDH.iProperty_Document_Hdr_id as PDHId,MS.iMast_Status_id as MastStatusId,MP.iMast_Property_Id as MastPropertyid,convert(varchar(22),PDH.dUpdated_dt,121) as UpdateDt,
				   Format(PDH.dCreate_dt,''MM/dd/yyyy hh:mm tt'')as CreateOn,
				   
				   MP.cProperty_Id as PropertyId, MSC.cSub_Category as [Sub Category],FORMAT(isnull(MSR.iSort_Order,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status as SortOrder,
				   isnull((select STUFF((SELECT '', '' + convert(varchar(10),PDHL.dCreate_dt,101)+ '' '' + CONVERT(VARCHAR(5), PDHL.dCreate_dt, 108) + '' : '' + convert(varchar(2000), MED.cEmpName) + '' : '' + convert(varchar(max), cRemarks, 2000) 
							FROM Property_Document_Hdr_log PDHL INNER JOIN ASTIL_Admin.dbo.Mast_Users MUD on MUD.iUser_id=PDHL.iUser_id Left Join ASTIL_Admin.dbo.Mast_Employee MED ON MED.iEmp_id=MUD.iEmp_id where iPost_Type=2 and iProperty_Document_Hdr_id=PDH.iProperty_Document_Hdr_id FOR XML PATH ('''')), 1, 1, '''') ), '''') as Comments,
							PDH.bStatus, PDH.cBBForms_Data_id
 FROM ASTIL_RealServ..Doc_Template DT
 INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id
 INNER JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
 INNER JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id    
	INNER JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=isnull(PDH.iUpd_User_id,PDH.iUser_id)
	Left Join ASTIL_Admin.dbo.Mast_Employee ME ON ME.iEmp_id=MU.iEmp_id
	left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id
 INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=DT.iCompany_id
	INNER join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus
	Left Join ASTIL_RealServ..Mast_Status_Rights MSR On PDH.bStatus=MSR.iMast_Status_id And PDH.iCompany_id=MSR.iCompany_id And PDH.iDoc_Template_id=MSR.iDoc_Template_id and MSR.bActive=1
	Left Join ASTIL_Admin.dbo.Mast_Company_info MCIR On MCIR.iCompany_id=MSR.iCompany_id_Res
 Left Join Mast_Sub_Category MSC ON MSC.iMast_Sub_Category_Id=PDH.iMast_Sub_Category_Id
	where (isnull(''' +  convert(varchar(10),@FromDate,121) +''' ,'''')='''' or  (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' +  convert(varchar(10),@FromDate,121) +''' And  ''' +convert(varchar(10), @Todate,121) +''' ))
 and PDH.bActive=1 and ('+ cast(@companyid as varchar)+' = 0 OR PDH.iCompany_id= '+ cast(@companyid as varchar)+') and ('+ cast(@companyid as varchar)+'=0 or  (isnull('''+ CAST(@status as varchar)+''','''')='''' or PDH.bStatus in(SELECT Items FROM  Split('''+ CAST(@status as varchar)+''','',''))))
 ) x
   pivot (max(cColumn_Value) for         cColumn_Name  in (' + @cols + ')
  ) p Where iDoc_Template_id='+ cast(@iDoc_Template_id as varchar(50))+' Order by UpdateDt desc'
 
print @query
 
exec (@query)
	end
	if @opt=16
	begin
	update Property_Document_Hdr set bActive=0 ,bStatus=0 where iProperty_Document_Hdr_id=@PDHId and iDoc_Template_id=@iDoc_Template_id
	end
	if @opt=17
	begin
	
	update Property_Document_Hdr set bActive=1 ,bStatus=1 where iProperty_Document_Hdr_id=@PDHId and iDoc_Template_id=@iDoc_Template_id
	end
	if @opt=18
	begin
	select distinct cDoc_Template_Name,cProperty_Alais_Name from Doc_Template where iDoc_Template_id=@iDoc_Template_id 
	end
	if @opt=19
	begin
		Declare @strQry_val as Varchar(max)
		Select @strQry_val=cColumn_Def_Value from Doc_Template_Dtl Where iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id
		If Len(@strQry_val) > 0
		Begin
			Exec(@strQry_val)
		End
		Else
		Begin
			--Select cValues,cLabel_Name,iDoc_Template_Dtl_Values_id from Doc_Template_Dtl_Values Where iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id
			
			--Select distinct cValues,cLabel_Name,iDoc_Template_Dtl_Values_id,DTDV.iDoc_Template_Dtl_id from Doc_Template_Dtl_Values  DTDV inner join Property_Document_Dtl_Desc PDDD
			--on DTDV.iDoc_Template_Dtl_id=PDDD.iDoc_Template_Dtl_id
			--Where 
			--DTDV.iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id and DTDV.bActive=1 and iProperty_Document_Dtl_id=@iProperty_Document_Dtl_id

		--		select  DTV.cValues,DTV.cLabel_Name ,DTV.iDoc_Template_Dtl_Values_id, PDD.iProperty_Document_Dtl_Desc_id,
		--PDD.cColumn_Value
		--	from Doc_Template_Dtl_Values DTV
		--	left join Property_Document_Dtl_Desc PDD on DTV.iDoc_Template_Dtl_id = PDD.iDoc_Template_Dtl_id 
		--		and DTV.cLabel_Name = PDD.cColumn_Name 
		--	 where DTV.iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id 
		--     and iProperty_Document_Dtl_id=@iProperty_Document_Dtl_id


			select   DTV.cValues,DTV.cLabel_Name ,DTV.iDoc_Template_Dtl_Values_id,ISNULL(PDD.iProperty_Document_Dtl_Desc_id ,'') as iProperty_Document_Dtl_Desc_id, 
		   isnull (PDD.cColumn_Value,'' ) as cColumn_Value,isnull (iProperty_Document_Dtl_id,'' ) as iProperty_Document_Dtl_id
			from Doc_Template_Dtl_Values DTV
			left join Property_Document_Dtl_Desc PDD on DTV.iDoc_Template_Dtl_id = PDD.iDoc_Template_Dtl_id  and  iProperty_Document_Dtl_id=@iProperty_Document_Dtl_id
				and DTV.cLabel_Name = PDD.cColumn_Name 
			 where DTV.iDoc_Template_Dtl_id=@iDoc_Template_Dtl_id 

			


		End

	end
	if @opt=20
	begin	
		--select distinct iCompany_id_Res from ASTIL_RealServ..Mast_Status_Rights where iCompany_id =@iCompany_id and iDoc_Template_id=@iDoc_Template_id  and bActive=1
		Select distinct MSR.iCompany_id_Res,MSR.iMast_Status_id,Case When MSR.iCompany_id_Res=@iCompany_id then 1 else 0 End as StatusEditable
		from Property_Document_Hdr PDH
		inner join Mast_Status_Rights MSR On PDH.bStatus=MSR.iMast_Status_id And PDH.iCompany_id=MSR.iCompany_id And PDH.iDoc_Template_id=MSR.iDoc_Template_id
		where PDH.iProperty_Document_Hdr_id=@PDHId
		and MSR.bActive=1
	end
	if @opt=21
	begin	
		select  top 1 DATEDIFF( day , dProperty_Doc_dt-1 , getdate()) as days from Property_Document_Hdr where iCompany_id=@iCompany_id and bActive=1 order by dProperty_Doc_dt asc 
	end
	if @opt=22
	begin	
	

			--select distinct   convert(varchar,isnull([StartDate],[EndDate]),101) as [StartDate]
			--,convert(varchar,[EndDate],101) as [EndDate] , datediff(D, isnull([StartDate],[EndDate]) ,[EndDate]) as Days,iMast_Property_Id,
			--isnull([sTenant_Name],'') as [sTenant_Name],cProperty_Name,cMast_Status,cLogin,iProperty_Document_Hdr_id , iProperty_Document_Hdr_log_id,cStatus_Colour from (
			--select   StartDate=(
			--select distinct  convert(date,max(dCreate_dt))
			---- isnull(max(convert(Varchar(10),dCreate_dt,101) ),'') 
			--from Property_Document_Hdr_log PDHL 
			--where PDHL.iProperty_Document_Hdr_log_id <PDL.iProperty_Document_Hdr_log_id
			--AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id
			--),
			--[EndDate]=(
			--select convert(date,max(PDHL.dCreate_dt))			 
			---- max(convert(Varchar(10),PDHL.dCreate_dt,101) ) 
			--from Property_Document_Hdr_log PDHL
			--where PDHL.iProperty_Document_Hdr_log_id =PDL.iProperty_Document_Hdr_log_id
			--AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id
			--) 
			--, PD.iMast_Property_Id,MP.cProperty_Name,MS.cMast_Status,MU.cLogin,PD.iProperty_Document_Hdr_id
			--, PDL.iProperty_Document_Hdr_log_id,MS.cStatus_Colour,CAST(cColumn_Value as varchar(8000))  as  [sTenant_Name]
			--from Property_Document_Hdr PD 
			--inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
			--inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
			--inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus			
			--inner join ASTIL_Admin..Mast_Users MU on MU.iUser_id=PDL.iUser_id
			--left join Property_Document_Hdr_Desc PDHD on PDHD.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id and PDHD.bActive=1 and PDHD.cColumn_Name like '%Tenant%'
			--where 
			--(convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(10),@FromDate,121) and Convert(Varchar(10),@Todate,121))
			--and  PD.iCompany_id =@companyid	and PD.iDoc_Template_id=@iDoc_Template_Dtl_id and PD.bActive=1 
			--and  (isnull(@status+ CAST('' as varchar)+'','')='' or
			--MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
			
			----and (('2836,2821,2861,2861,2861,2863' <>'' and PD.iProperty_Document_Hdr_id  in  ('2836,2821,2861,2861,2861,2863')) or '2836,2821,2861,2861,2861,2863'='')
			----and (( PD.iProperty_Document_Hdr_id <>'' and PD.iProperty_Document_Hdr_id  in (SELECT Items FROM  Split (@PDHId_str,','))) or  @PDHId_str='')
			--and (( PDL.iProperty_Document_Hdr_log_id <>'' and PDL.iProperty_Document_Hdr_log_id  in (SELECT Items FROM  Split (@PDHId_str,','))) or  @PDHId_str='')
			----(CONVERT (int, @PDHId_str))
			-----(isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))

			--  )A

			select distinct   convert(varchar,isnull([StartDate],[EndDate]),101) as [StartDate]
			,convert(varchar,[EndDate],101) as [EndDate] , datediff(D, isnull([StartDate],[EndDate]) ,[EndDate]) as Days,iMast_Property_Id,
			isnull([sTenant_Name],'') as [sTenant_Name],cProperty_Name,cMast_Status,cLogin,iProperty_Document_Hdr_id , iProperty_Document_Hdr_log_id,cStatus_Colour from (
			select   StartDate=(
            --select distinct  convert(date,max(dCreate_dt))
            --from Property_Document_Hdr_log PDHL 
            --where PDHL.iProperty_Document_Hdr_log_id <=PDL.iProperty_Document_Hdr_log_id
            --AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id
             pdl.dCreate_dt
            ),
            [EndDate]=(
            --select  max(convert(Varchar(10),PDHL.dCreate_dt,101) ) 
            --from Property_Document_Hdr_log PDHL
            --where PDHL.iProperty_Document_Hdr_log_id >=PDL.iProperty_Document_Hdr_log_id
            --AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id 
                -- pdl.dUpdated_dt
				 case when pdl.dCreate_dt= pdl.dUpdated_dt then GETDATE() else pdl.dUpdated_dt end
            ) 
			, PD.iMast_Property_Id,MP.cProperty_Name,MS.cMast_Status,MU.cLogin,PD.iProperty_Document_Hdr_id
			, PDL.iProperty_Document_Hdr_log_id,MS.cStatus_Colour,CAST(cColumn_Value as varchar(8000))  as  [sTenant_Name]
			from Property_Document_Hdr PD 
			inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
			inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
			
			inner join Mast_Status_Rights MSR on MSR.iMast_Status_id=PDL.bStatus
			inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
			inner join ASTIL_Admin..Mast_Users MU on MU.iUser_id=PDL.iUser_id
			left join Property_Document_Hdr_Desc PDHD on PDHD.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id and PDHD.bActive=1 and PDHD.cColumn_Name like '%Tenant%'
			where 
			(convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(10),@FromDate,121) and Convert(Varchar(10),@Todate,121))
			and  PD.iCompany_id =@companyid	and PD.iDoc_Template_id=@iDoc_Template_Dtl_id and PD.bActive=1 and PDL.iPost_Type=1  and PDL.cRemarks not like '%File Uploaded Successfully%' and PDL.cRemarks not like '%File Deleted Successfully%'
			and MSR.bActive=1  AND MS.bActive=1  and MSR.iDoc_Template_id=@iDoc_Template_Dtl_id and MSR.iCompany_id=@companyid
			and  (isnull(@status+ CAST('' as varchar)+'','')='' or
			MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
			
			--and (('2836,2821,2861,2861,2861,2863' <>'' and PD.iProperty_Document_Hdr_id  in  ('2836,2821,2861,2861,2861,2863')) or '2836,2821,2861,2861,2861,2863'='')
			--and (( PD.iProperty_Document_Hdr_id <>'' and PD.iProperty_Document_Hdr_id  in (SELECT Items FROM  Split (@PDHId_str,','))) or  @PDHId_str='')
			and (( PDL.iProperty_Document_Hdr_log_id <>'' and PDL.iProperty_Document_Hdr_log_id  in (SELECT Items FROM  Split (@PDHId_str,','))) or  @PDHId_str='')
			--(CONVERT (int, @PDHId_str))
			---(isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))

			  )A
			

	end
	if @opt=23
	---Status
	begin
	 
--DECLARE @colnameList varchar(max)
--       SET @colnameList = NULL
--       SET @colnameList = STUFF((SELECT distinct ',' + QUOTENAME(MS.cMast_Status) 
--           from Mast_Status_Rights MSR 
--			--inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
--			--inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
--			--inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
--			inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
--	        inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id	
--			--where (convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(10),@FromDate,121) and Convert(Varchar(10),@Todate,121))
--			--and  PD.iCompany_id =@companyidchar	and PD.iDoc_Template_id=@iDoc_Template_Dtl_idchar and PD.bActive=1 and 
--			where MSR.bActive=1  AND MS.bActive=1 and DT.bActive=1 and MSR.iDoc_Template_id=@iDoc_Template_Dtl_idchar and MSR.iCompany_id=@companyidchar
--			and  (isnull(@status+ CAST('' as varchar)+'','')='' or MS.iMast_Status_id in(SELECT Items FROM  Split(@status,',')))
--            FOR XML PATH(''), TYPE
--            ).value('.', 'NVARCHAR(MAX)') 
--        ,1,1,'')
		
--DECLARE @SQLQuery NVARCHAR(MAX)=''
--SET @SQLQuery =
--'Select * from(
--  select distinct cProperty_Name as [Property], isnull([sTenant_Name],'''') as [Tenant_Name],cLogin as [User],convert(varchar,isnull([StartDate],[EndDate]),101) as [StartDate]
--			,convert(varchar,[EndDate],101) as [EndDate] , datediff(D, isnull([StartDate],[EndDate]) ,[EndDate]) as Days,cMast_Status,iProperty_Document_Hdr_log_id
--			from (
--			select   StartDate=(
--			select distinct  convert(date,max(dCreate_dt))
--			from Property_Document_Hdr_log PDHL 
--			where PDHL.iProperty_Document_Hdr_log_id <PDL.iProperty_Document_Hdr_log_id
--			AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id
--			),
--			[EndDate]=(
--			select convert(date,max(PDHL.dCreate_dt))
--			-- max(convert(Varchar(10),PDHL.dCreate_dt,101) ) 
--			from Property_Document_Hdr_log PDHL
--			where PDHL.iProperty_Document_Hdr_log_id =PDL.iProperty_Document_Hdr_log_id
--			AND PDHL.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id
--			) 
--			, PD.iMast_Property_Id,MP.cProperty_Name,MS.cMast_Status,MU.cLogin,PD.iProperty_Document_Hdr_id
--			, PDL.iProperty_Document_Hdr_log_id,MS.cStatus_Colour,CAST(cColumn_Value as varchar(8000))  as  [sTenant_Name]
--			from Property_Document_Hdr PD 
--			inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
--			inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
--			inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
--			inner join ASTIL_Admin..Mast_Users MU on MU.iUser_id=PDL.iUser_id
--			left join Property_Document_Hdr_Desc PDHD on PDHD.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id and PDHD.bActive=1 and PDHD.cColumn_Name like ''%Tenant%''	
--			where 
--			(convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(10),'''+@FromDate+''',121) and Convert(Varchar(10),'''+@Todate+''',121))
--			and  PD.iCompany_id ='''+@companyidchar+'''	and PD.iDoc_Template_id='''+@iDoc_Template_Dtl_idchar+''' and PD.bActive=1 
--			and  (isnull('''+@status+'''+ CAST('''' as varchar)+'''','''')='''' or MS.iMast_Status_id in(SELECT Items FROM  Split('''+@status+''','','')))
--			  )A
--			  )B
--			  PIVOT    
--         (SUM(Days) FOR cMast_Status IN ('+@colnameList+')) AS Tab2'


--       Print @SQLQuery

--       Execute sp_executesql @SQLQuery
       




		  
		DECLARE @colnameList varchar(max)
         Create Table #tempAuditDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id int ,iDoc_Template_id Int,iDoc_Template_Dtl_id int,iCompany_id Int, iTo_User_Id Int, iIsVisible Int, bActive Int)  
         Create Table #tempAuditdata(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max),iProperty_Document_Hdr_id int,cColumn_Value nvarchar(max), iSort_Order Int)  
         Create Table #tempAuditclmname(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max), iSort_Order Int) 
       SET @colnameList = NULL
       ;with Temp1(cMast_Status,iMast_Status_id,iSort_Order)
       as (SELECT   --ROW_NUMBER() over (order by MSR.iSort_Order,MsR.iMast_Status_id asc),
       MS.cMast_Status,MSR.iMast_Status_id,MSR.iSort_Order
           from Mast_Status_Rights MSR 
            inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
            inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id    
            where MSR.bActive=1  AND MS.bActive=1 and DT.bActive=1 and MSR.iDoc_Template_id=@iDoc_Template_Dtl_id and MSR.iCompany_id=@companyid
            --and  (isnull(@status+ CAST('' as varchar)+'','')='' or MS.iMast_Status_id in(SELECT Items FROM  Split(@status,',')))
and  (isnull(@status+ CAST('' as varchar)+'','')='' or
			MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
            )

            Select   * into #temp1 from Temp1
            ---Column and value------

            insert into #tempAuditDoc_Template_Dtl_Visible(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 

            Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
            Where iCompany_id=@companyid and iDoc_Template_id=@iDoc_Template_Dtl_id and iTo_User_Id=@Userid

               insert into #tempAuditdata(cColumn_Name,iProperty_Document_Hdr_id,cColumn_Value,iSort_Order) 
               SELECT  RTRIM( LTRIM( cColumn_Name)) as cColumn_Name,PDDD.iProperty_Document_Hdr_id,cColumn_Value,DTD.iSort_Order
               FROM ASTIL_RealServ..Doc_Template DT
               INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id and DTD.bActive=1
               LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
               left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id  and PDH.bActive=1  
               left JOIN ASTIL_RealServ..Property_Document_Hdr_log PDL ON PDH.iProperty_Document_Hdr_id = PDL.iProperty_Document_Hdr_id 
               inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
               Left Join #tempAuditDoc_Template_Dtl_Visible DTV ON DTD.iDoc_Template_Dtl_id=DTV.iDoc_Template_Dtl_id and DTV.iCompany_id=PDH.iCompany_id and DTV.bActive=1 and DTV.iIsVisible=1
               LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
               LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=PDH.iCompany_id
               where PDH.bActive=1 and DT.iDoc_Template_id=@iDoc_Template_Dtl_id --and PDH.iCompany_id=@companyid
               and (isnull(@FromDate,'')='' or convert(varchar(10),PDH.dProperty_Doc_dt,121) between convert(varchar(10),@FromDate,121)  And  convert(varchar(10), @Todate,121) )
               and (isnull(@companyid,'') ='' or PDH.iCompany_id= @companyid) 
--and (isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))
and (isnull(@status+ CAST('' as varchar)+'','')='' or
			MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
               Order by DTD.iSort_Order
       			Insert into #tempAuditclmname(cColumn_Name,iSort_Order)
       			select distinct cColumn_Name,iSort_Order from #tempAuditdata  order by iSort_Order option (force order)
        --Select * from #tempclmname
           ;with Temp6(SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName) 
as( select 1 as SNo, iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Normal'
union all
select 2, iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Super'
union all
select 3,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Restricted'
union all
select 4,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Production'
union all
select 5,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='MG'
union all
select 6,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='SM'
union all
select 7,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='AM'
	union all
	 select 8,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='SA'
	 union all
	 select 9,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='DR')
Select * into #temp6 from Temp6

        set @cols=(Select stuff((select '[' + Convert(varchar(max),cColumn_Name) + '],' from #tempAuditclmname FOR XML PATH('')),1,0,''))
        set @cols= LEFT(@cols, LEN(@cols) - 1)     
        print @cols
        drop table #tempAuditdata
        drop table #tempAuditDoc_Template_Dtl_Visible
        drop table #tempAuditclmname
        select distinct  @colnameList = STUFF((SELECT  ',' + QUOTENAME(cMast_Status) 
           from #temp1
            group by iSort_Order,cMast_Status
            order by iSort_Order,cMast_Status asc
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
        --Select @colnameList
         Drop table #temp1
DECLARE @SQLQuery NVARCHAR(MAX)=''
print 'data'
print @companyid
print @FromDate
SET @SQLQuery ='Select  * from(
    select distinct cProperty_Name as [Property],cColumn_Name,cast(isnull(cColumn_Value,'''') as varchar(max)) as cColumn_Value,case when iUser_Display_Type=0 then cLogin when iUser_Display_Type=1 then Property_Manager_Name else cLogin end as [User],convert(varchar,isnull([StartDate],[EndDate]),101) as [StartDate]
            ,convert(varchar,[EndDate],101) as [EndDate] , datediff(D, isnull([StartDate],[EndDate]) ,[EndDate]) as Days,cMast_Status,iProperty_Document_Hdr_log_id,iProperty_Document_Hdr_id           
           from (
            select   StartDate=(
            pdl.dCreate_dt
            ),
            [EndDate]=(
            case when pdl.dCreate_dt= pdl.dUpdated_dt then GETDATE() else pdl.dUpdated_dt end
            ) ,
Property_Manager_Name=(select top 1 cProperty_Manager_Name
from Mast_Property_Manager MPR
inner join #temp6 temp on MPR.iRole_Type_id=temp.iRole_Type_id
where MPR.bActive=1 and MPM.iMast_Property_Id=MPR.iMast_Property_Id  order by SNo)
            , PD.iMast_Property_Id,MP.cProperty_Name,MS.cMast_Status,MU.cLogin,PD.iProperty_Document_Hdr_id
            , PDL.iProperty_Document_Hdr_log_id,MS.cStatus_Colour,CAST(cColumn_Value as varchar(8000))  as  [cColumn_Value],cColumn_Name,MAL.iUser_Display_Type ,PDL.iUser_id
            from Property_Document_Hdr PD 
            inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
            inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
            inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
            inner join ASTIL_Admin..Mast_Users MU on MU.iUser_id=PDL.iUser_id
            left join Mast_Audit_Log_Report_Settings MAL on MAL.iMast_Status_id=MS.iMast_Status_id  and PD.iDoc_Template_id=MAL.iDoc_Template_id and MAL.bActive=1
            left join Mast_Property_Manager MPM on PD.iMast_Property_Id=MPM.iMast_Property_Id and MPM.bActive=1 
            left join Property_Document_Hdr_Desc PDHD on PDHD.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id and PDHD.bActive=1 
            where 
            (convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(20),'''+@FromDate+''') and Convert(Varchar(20),'''+@Todate+''',121))
            and  PD.iCompany_id ='''+ cast(@companyid as varchar(50))+''' 
			and PD.iDoc_Template_id='+ cast(@iDoc_Template_Dtl_id as varchar(50))+'
			and PD.bActive=1 and PDL.iPost_Type=1  and PDL.cRemarks not like ''%File Uploaded Successfully%'' and PDL.cRemarks not like ''%File Deleted Successfully%''
           and  (isnull('''+@status+'''+ CAST('''' as varchar)+'''','''')='''' or MS.iMast_Status_id in(SELECT Items FROM  Split('''+@status+''','','')))
              )A
              )B
              PIVOT  
         (max(cColumn_Value)for cColumn_Name  in (' + @cols + ')) As Tab1
              PIVOT    
         (SUM(Days) FOR cMast_Status IN ('+@colnameList+')) AS Tab2 order by iProperty_Document_Hdr_id asc'
       Print @SQLQuery
       Execute sp_executesql @SQLQuery
Drop table #temp6
	end
	if @opt=24
	begin
		Select distinct  ISNULL(MCI.iCompany_id,'') as iCompany_id,
		DocT.iDoc_Template_id as id,DocT.cDoc_Template_Name as [name],MCI.cCompany_Name, isnull(DocT.cBBForms_id,'') as BBFormID,
		isnull(cBBForms_AbsData_id,'') as BBFormAbsID , PDH.sTenant_Name as tenantName
		From Property_Document_Hdr PDH
		Inner Join Doc_Template DT On PDH.iDoc_Template_id=DT.iDoc_Template_id 
		Inner Join ASTIL_Admin.dbo.Mast_Company_info MCI On MCI.iCompany_id=PDH.iCompany_id
		Inner Join Doc_Template DocT On DocT.iDoc_Template_id=DT.iDoc_Template_id_Abstract
		where  DocT.bActive=1 And DocT.iTemplate_Type=2 and PDH.iCompany_id=@Companyid and PDH.iProperty_Document_Hdr_id=@PDHId
		and DocT.cBBForms_id is not null 
		order by  DocT.iDoc_Template_id asc

	 --   select distinct  ISNULL(MCI.iCompany_id,'') as iCompany_id,
		--DocT.iDoc_Template_id as id,cDoc_Template_Name as [name],MCI.cCompany_Name, isnull(DocT.cBBForms_id,'') as BBFormID,
		--isnull((Select top 1 cBBForms_AbsData_id from Property_Document_Hdr PDH Where PDH.iDoc_Template_id=DocT.iDoc_Template_id and PDH.iCompany_id=@Companyid and PDH.iProperty_Document_Hdr_id=@PDHId),'') as BBFormAbsID
		--from ASTIL_Admin.dbo.Mast_Company_info MCI
		--inner join Doc_Template_Company_Rights DTCR on DTCR.iCompany_id=MCI.iCompany_id
		--inner join Doc_Template_User_Rights DTUR on DTUR.iDoc_Template_Company_Rights_ID=DTCR.iDoc_Template_Company_Rights_ID
		--inner join Doc_Template DocT on DocT.iDoc_Template_id =DTCR.iDoc_Template_id 		
		--where  DTCR.bactive=1 and DocT.bActive=1 and MCI.bActive=1  and DTUR.bactive=1 And DocT.iTemplate_Type=2 
		--and DocT.cBBForms_id is not null and DTCR.iCompany_id=@Companyid and DTUR.iUser_id=@Userid --and DocT.iDoc_Template_id=@iDoc_Template_id
		--and  DTCR.iCompany_id in(SELECT iCompany_id FROM ASTIL_Admin..Mast_Company_User_Rights UR Where UR.bActive=1 and UR.iComp_User_Id =@Userid and iCompany_id=@Companyid)
		--order by  DocT.iDoc_Template_id asc

	end
	
	--Select the Tenant Name and code against the property
	IF @opt=25
	BEGIN
		
		SELECT * FROM Mast_Tenant A
		LEFT JOIN Mast_Property B ON A.iMast_Property_Id = B.iMast_Property_Id 
		WHERE A.bActive=1 and B.bActive=1 and A.iMast_Property_Id = @iMast_Property_Id
			
	END

	--Insert the tenant details
	IF @opt=26
	BEGIN
		IF NOT EXISTS(SELECT * FROM Mast_Tenant WHERE iMast_Property_Id=@iMast_Property_Id 
		and cTenant_Code=@cTenant_Code and bActive=1)
		BEGIN
			INSERT INTO Mast_Tenant 
			(iMast_Property_Id, cTenant_Name, cTenant_Code, bActive, dCreate_dt)
			VALUES 
			(@iMast_Property_Id, @cTenant_Name, @cTenant_Code, 1, GETDATE());
			RETURN 1; 
		END
		ELSE
		BEGIN
			RETURN 2;
		END
	END

	--Update the tenant details
	IF @opt=27
	BEGIN
		IF NOT EXISTS(SELECT * FROM Mast_Tenant WHERE iMast_Property_Id=@iMast_Property_Id 
		and cTenant_Code=@cTenant_Code and bActive=1)
		BEGIN
			UPDATE Mast_Tenant SET 
			cTenant_Name=@cTenant_Name, 
			cTenant_Code=@cTenant_Code
			WHERE 
			iMast_Tenant_id=@iMast_Tenant_id

			RETURN 3; 
		END 
		ELSE 
		BEGIN
			RETURN 4;
		END
	END

	--Delete the tenant details
	IF @opt=28
	BEGIN
		UPDATE Mast_Tenant SET
		bActive=0
		WHERE 
		iMast_Tenant_id=@iMast_Tenant_id
	END

	if @opt=29
	---Status
	begin
    DECLARE @colnameList1 varchar(max)
         Create Table #tempAuditDoc_Template_Dtl_Visible1(iDoc_Template_Dtl_Visible_id int ,iDoc_Template_id Int,iDoc_Template_Dtl_id int,iCompany_id Int, iTo_User_Id Int, iIsVisible Int, bActive Int)  
         Create Table #tempAuditdata1(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max),iProperty_Document_Hdr_id int,cColumn_Value nvarchar(max), iSort_Order Int)  
         Create Table #tempAuditclmname1(Id int identity(1,1) primary key clustered,cColumn_Name nvarchar(max), iSort_Order Int) 
       SET @colnameList1 = NULL
       ;with Temp2(cMast_Status,iMast_Status_id,iSort_Order)
       as (SELECT   --ROW_NUMBER() over (order by MSR.iSort_Order,MsR.iMast_Status_id asc),
       MS.cMast_Status,MSR.iMast_Status_id,MSR.iSort_Order
           from Mast_Status_Rights MSR 
            inner join Doc_Template DT on DT.iDoc_Template_id=MSR.iDoc_Template_id
            inner join Mast_Status MS on MS.iMast_Status_id=MSR.iMast_Status_id    
            where MSR.bActive=1  AND MS.bActive=1 and DT.bActive=1 and MSR.iDoc_Template_id=@iDoc_Template_Dtl_id and MSR.iCompany_id=@companyid
            --and  (isnull(@status+ CAST('' as varchar)+'','')='' or MS.iMast_Status_id in(SELECT Items FROM  Split(@status,',')))
and  (isnull(@status+ CAST('' as varchar)+'','')='' or
			MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
            )

            Select   * into #temp2 from Temp2
            ---Column and value------

            insert into #tempAuditDoc_Template_Dtl_Visible1(iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive) 

            Select iDoc_Template_Dtl_Visible_id,iDoc_Template_id,iDoc_Template_Dtl_id,iCompany_id,iTo_User_Id,iIsVisible, bActive From Doc_Template_Dtl_Visible 
            Where iCompany_id=@companyid and iDoc_Template_id=@iDoc_Template_Dtl_id and iTo_User_Id=@Userid

               insert into #tempAuditdata1(cColumn_Name,iProperty_Document_Hdr_id,cColumn_Value,iSort_Order) 
               SELECT  RTRIM( LTRIM( cColumn_Name)) as cColumn_Name,PDDD.iProperty_Document_Hdr_id,cColumn_Value,DTD.iSort_Order
               FROM ASTIL_RealServ..Doc_Template DT
               INNER JOIN ASTIL_RealServ..Doc_Template_Dtl DTD ON DTD.iDoc_Template_id = DT.iDoc_Template_id and DTD.bActive=1
               LEFT JOIN ASTIL_RealServ..Property_Document_Hdr_Desc PDDD ON DTD.iDoc_Template_Dtl_id = PDDD.iDoc_Template_Dtl_id and PDDD.bActive=1
               left JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iProperty_Document_Hdr_id = PDDD.iProperty_Document_Hdr_id  and PDH.bActive=1  
               left JOIN ASTIL_RealServ..Property_Document_Hdr_log PDL ON PDH.iProperty_Document_Hdr_id = PDL.iProperty_Document_Hdr_id 
               inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
               Left Join #tempAuditDoc_Template_Dtl_Visible1 DTV ON DTD.iDoc_Template_Dtl_id=DTV.iDoc_Template_Dtl_id and DTV.iCompany_id=PDH.iCompany_id and DTV.bActive=1 and DTV.iIsVisible=1
               LEFT JOIN ASTIL_RealServ..Mast_Task MG ON MG.iMast_Task_id = PDH.iMast_Task_id
               LEFT JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=PDH.iCompany_id
               where PDH.bActive=1 and DT.iDoc_Template_id=@iDoc_Template_Dtl_id --and PDH.iCompany_id=@companyid
               and (isnull(@FromDate,'')='' or convert(varchar(10),PDH.dProperty_Doc_dt,121) between convert(varchar(10),@FromDate,121)  And  convert(varchar(10), @Todate,121) )
               and (isnull(@companyid,'') ='' or PDH.iCompany_id= @companyid) 
--and (isnull(@status,'')='' or  PDH.bStatus in(SELECT Items FROM  Split(@status,',')))
and (isnull(@status+ CAST('' as varchar)+'','')='' or
			MS.iMast_Status_id in(SELECT Items FROM  Split(@status + CAST('' as varchar)+'',',')))
               Order by DTD.iSort_Order
       			Insert into #tempAuditclmname1(cColumn_Name,iSort_Order)
       			select distinct cColumn_Name,iSort_Order from #tempAuditdata1  order by iSort_Order option (force order)
        --Select * from #tempclmname
           ;with Temp7(SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName) 
as( select 1 as SNo, iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Normal'
union all
select 2 as SNo, iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Super'
union all
select 3 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Restricted'
union all
select 4 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='Production'
union all
select 5 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='MG'
union all
select 6 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='SM'
union all
select 7 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='AM'
	union all
	 select 8 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='SA'
	 union all
	 select 9 as SNo,iRole_Type_id,cRoleType_Name,cRoleType_ShortName from ASTIL_Admin..Mast_Role_Type where bActive=1 and cRoleType_ShortName='DR')
Select * into #temp7 from Temp7

        set @cols1=(Select stuff((select '[' + Convert(varchar(max),cColumn_Name) + '],' from #tempAuditclmname1 FOR XML PATH('')),1,0,''))
        set @cols1= LEFT(@cols1, LEN(@cols1) - 1)     
        print @cols1
        drop table #tempAuditdata1
        drop table #tempAuditDoc_Template_Dtl_Visible1
        drop table #tempAuditclmname1
        select distinct  @colnameList1 = STUFF((SELECT  ',' + QUOTENAME(cMast_Status) 
           from #temp2
            group by iSort_Order,cMast_Status
            order by iSort_Order,cMast_Status asc
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')
        --Select @colnameList
         Drop table #temp2
DECLARE @SQLQuery1 NVARCHAR(MAX)=''
print 'data'
print @companyid
print @FromDate
SET @SQLQuery1 ='Select  * from(
    select distinct cProperty_Name as [Property],uniqueID,cBBForms_id,cColumn_Name,cast(isnull(cColumn_Value,'''') as varchar(max)) as cColumn_Value,case when iUser_Display_Type=0 then cLogin when iUser_Display_Type=1 then Property_Manager_Name else cLogin end as [User],convert(varchar,isnull([StartDate],[EndDate]),101) as [StartDate]
            ,convert(varchar,[EndDate],101) as [EndDate] , datediff(D, isnull([StartDate],[EndDate]) ,[EndDate]) as Days,cMast_Status,iProperty_Document_Hdr_log_id,iProperty_Document_Hdr_id           
           from (
            select   StartDate=(
            pdl.dCreate_dt
            ),
            [EndDate]=(
            case when pdl.dCreate_dt= pdl.dUpdated_dt then GETDATE() else pdl.dUpdated_dt end
            ) ,
Property_Manager_Name=(select top 1 cProperty_Manager_Name
from Mast_Property_Manager MPR
inner join #temp7 temp on MPR.iRole_Type_id=temp.iRole_Type_id
where MPR.bActive=1 and MPM.iMast_Property_Id=MPR.iMast_Property_Id  order by SNo)
            , PD.iMast_Property_Id,PD.cBBForms_Data_id as uniqueID,MP.cProperty_Name,MS.cMast_Status,MU.cLogin,PD.iProperty_Document_Hdr_id
            , PDL.iProperty_Document_Hdr_log_id,MS.cStatus_Colour,CAST(cColumn_Value as varchar(8000))  as  [cColumn_Value],cColumn_Name,MAL.iUser_Display_Type ,PDL.iUser_id, DT.cBBForms_id
            from Property_Document_Hdr PD 
			left join Doc_Template DT ON DT.iDoc_Template_id=PD.iDoc_Template_id
            inner join Mast_Property MP on MP.iMast_Property_Id=PD.iMast_Property_Id
            inner join Property_Document_Hdr_log PDL on PD.iProperty_Document_Hdr_id=PDL.iProperty_Document_Hdr_id
            inner join Mast_Status MS on MS.iMast_Status_id=PDL.bStatus
            inner join ASTIL_Admin..Mast_Users MU on MU.iUser_id=PDL.iUser_id
            left join Mast_Audit_Log_Report_Settings MAL on MAL.iMast_Status_id=MS.iMast_Status_id  and PD.iDoc_Template_id=MAL.iDoc_Template_id and MAL.bActive=1
            left join Mast_Property_Manager MPM on PD.iMast_Property_Id=MPM.iMast_Property_Id and MPM.bActive=1 
            left join Property_Document_Hdr_Desc PDHD on PDHD.iProperty_Document_Hdr_id=PD.iProperty_Document_Hdr_id and PDHD.bActive=1 
            where 
            (convert(Varchar(10),PDL.dCreate_dt,121) between Convert(Varchar(20),'''+@FromDate+''') and Convert(Varchar(20),'''+@Todate+''',121))
            and  PD.iCompany_id ='''+ cast(@companyid as varchar(50))+''' 
			and PD.iDoc_Template_id='+ cast(@iDoc_Template_Dtl_id as varchar(50))+'
			and PD.bActive=1 and PDL.iPost_Type=1  and PDL.cRemarks not like ''%File Uploaded Successfully%'' and PDL.cRemarks not like ''%File Deleted Successfully%''
           and  (isnull('''+@status+'''+ CAST('''' as varchar)+'''','''')='''' or MS.iMast_Status_id in(SELECT Items FROM  Split('''+@status+''','','')))
              )A
              )B
              PIVOT  
         (max(cColumn_Value)for cColumn_Name  in (' + @cols1 + ')) As Tab1
              PIVOT    
         (SUM(Days) FOR cMast_Status IN ('+@colnameList1+')) AS Tab2 order by iProperty_Document_Hdr_id asc'
       Print @SQLQuery1
       Execute sp_executesql @SQLQuery1
Drop table #temp7
	end

	IF @opt=30
	BEGIN
		SELECT iProperty_Document_Hdr_id as PDHId, iMast_Property_Id, iMast_Tenant_id, iMast_Sub_Category_Id, bIs_Litigation, iDelete_Days,
		iComments_Delete_Days
		FROM ASTIL_RealServ..Property_Document_Hdr 
		WHERE iProperty_Document_Hdr_id= @PDHId
	END

	if @opt=31
	begin
		SELECT @iIsSortOrder_Needed = iIsSortOrder_Needed      
		,@iIsDocument_Needed = iIsDocument_Needed      
		,@iIsPropManager_Needed = iIsPropManager_Needed      
		FROM Doc_Template_Settings      
		WHERE iDoc_Template_id = @iDoc_Template_id      
		AND iCompany_id = @companyid      
		AND bActive = 1      
     
		SELECT @UserRoleType = MU.bSuperUser      
		FROM ASTIL_Admin.dbo.Mast_Users MU      
		WHERE iUser_id = @Userid      
      
		SELECT @DoctempSubCatReq = DT.iIsSubCategory_Req      
		FROM ASTIL_RealServ..Doc_Template DT      
		WHERE DT.iDoc_Template_id = @iDoc_Template_id     
 
		Declare @cProperty_Alais_Name as nvarchar(max);
		set @cProperty_Alais_Name = (SELECT  cProperty_Alais_Name FROM ASTIL_RealServ..Doc_Template where iDoc_Template_id=@iDoc_Template_id);
		set @UserRoleType= (SELECT MU.bSuperUser from ASTIL_Admin.dbo.Mast_Users MU Where iUser_id=@Userid);

		SET @query = 
		'SELECT	
		PropertyId AS  [Property Id], 
		PropertyName AS [Property Name], 
		cMast_Status AS [SortOrder],'+

		--cCompany_Name AS [Company Name],sTenant_Name AS [Tenant Name],
		--END + 'cCase_No AS [Case No],PDHId AS [PDHId],MastStatusId AS [Status Id],MastPropertyid AS [Mast Property Id],      
		--  ' + CASE @iIsDocument_Needed      --DocDate AS [Updated Date],
		--CASE @iIsSortOrder_Needed WHEN 1 THEN 
		--(convert(varchar(10), @iIsSortOrder_Needed_List)  AS  [iIsSortOrder_Needed_List],
	
		--CASE @iIsDocument_Needed WHEN 1 THEN 'cScan_Note_Name AS [Document Name],' ELSE '' END + '' +
		--CASE @iIsPropManager_Needed WHEN 1 THEN '[Property Manager],' ELSE '' END + 
		--CASE @DoctempSubCatReq WHEN 1 THEN '[Sub Category],' ELSE '' END + 
		--cCase_No AS [Case No],[Abrstract PDF], PDHId as [_id], cDoc_Template_Name AS [Template Name], 
		--iMast_Tenant_id AS [TenantId],iMast_Sub_Category_Id AS [SubCategory],iSort_Order,
		--templateId,iMast_Property_Id,MastStatusId AS [Status Id],cMast_Status AS [Status]

		'CreateOn AS [Created On],
		DocDate AS [Updated On],	
		UserName AS [Updated By],
		Comments, 
		cBBForms_Data_Id AS [mDataReturnId], 
		cBBFormId AS [Form Id],	
		PDHId	,
		cCase_No AS [Case No],[Abrstract PDF], PDHId as [_id], cDoc_Template_Name AS [Template Name], 
		iMast_Tenant_id AS [TenantId],iMast_Sub_Category_Id AS [SubCategory],iSort_Order,
		templateId,iMast_Property_Id,MastStatusId AS [Status Id],cMast_Status AS [Status]
			From         
		(        
			select ROW_NUMBER() OVER(PARTITION BY cCase_No ORDER BY PDH.dCreate_dt ASC) AS RowNum, DT.cDoc_Template_Name,
			MCI.cCompany_Name, MP.cProperty_Name as PropertyName, DT.cDoc_Template_Name as ProcessName, 
			ME.cEmpName as UserName,PDH.cScan_Note_Name,DT.cProperty_Alais_Name,' + 
			CASE @iIsSortOrder_Needed WHEN 1 THEN 
			'FORMAT(isnull(MSR.iSort_Order,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status'      
			ELSE 'MS.cMast_Status' END + ' as cMast_Status,   
			isnull((select STUFF((SELECT '', '' + convert(varchar(10),PDHL.dCreate_dt,101)+ '' '' + CONVERT(VARCHAR(5), PDHL.dCreate_dt, 108) + '' : '' + convert(varchar(2000), MED.cEmpName) + '' : '' + convert(varchar(max), cRemarks, 2000) 
			FROM Property_Document_Hdr_log PDHL INNER JOIN ASTIL_Admin.dbo.Mast_Users MUD on MUD.iUser_id=PDHL.iUser_id Left Join ASTIL_Admin.dbo.Mast_Employee MED ON MED.iEmp_id=MUD.iEmp_id where iPost_Type=2 and iProperty_Document_Hdr_id=PDH.iProperty_Document_Hdr_id FOR XML PATH ('''')), 1, 1, '''') ), '''') as Comments,
			PDH.cCase_No, Format(PDH.dUpdated_dt,''MM/dd/yyyy'') as DocDate, DT.iDoc_Template_id, 
			DT.iDoc_Template_id as templateId, PDH.iProperty_Document_Hdr_id as PDHId, MS.iMast_Status_id as MastStatusId,
			MP.iMast_Property_Id as MastPropertyid, convert(varchar(22), PDH.dUpdated_dt,121) as UpdateDt,        
			Format(PDH.dCreate_dt,''MM/dd/yyyy'') as CreateOn, isnull(Manager,'''') as [Property Manager],        
			MP.cProperty_Id as PropertyId, MSC.cSub_Category as [Sub Category],
			FORMAT(isnull(MSR.iSort_Order_Grid,''''),''0#'') + ''. '' + isnull(MCIR.cRes_ShortName,'''') + '' - '' + MS.cMast_Status as SortOrder,'
			+ Convert(VARCHAR(10), @UserRoleType) +' as UserRoleType, 
			MP.cProperty_Id as PropertyCode, PDH.cBBForms_Data_Id, 
			DT.cBBForms_id as cBBFormId, DT.iIs_Include_Abstract_Form as [Abrstract PDF],
			PDH.iMast_Tenant_id, PDH.sTenant_Name, PDH.iMast_Sub_Category_Id , MSR.iSort_Order, PDH.iMast_Property_Id
			FROM ASTIL_RealServ..Doc_Template DT               
			INNER JOIN ASTIL_RealServ..Property_Document_Hdr PDH ON PDH.iDoc_Template_id = DT.iDoc_Template_id            
			INNER JOIN ASTIL_Admin.dbo.Mast_Users MU on MU.iUser_id=isnull(PDH.iUpd_User_id,PDH.iUser_id)        
			Left Join ASTIL_Admin.dbo.Mast_Employee ME ON ME.iEmp_id=MU.iEmp_id        
			left join ASTIL_RealServ..Mast_Property MP on MP.iMast_Property_Id=PDH.iMast_Property_Id        
			left join ASTIL_RealServ..PropertyManager_view MPM on MPM.iMast_Property_Id=MP.iMast_Property_Id        
			INNER JOIN ASTIL_Admin..Mast_Company_info MCI ON MCI.iCompany_id=PDH.iCompany_id        
			INNER join ASTIL_RealServ..Mast_Status MS on MS.iMast_Status_id=PDH.bStatus and MS.bActive=1        
			Left Join ASTIL_RealServ..Mast_Status_Rights MSR On PDH.bStatus=MSR.iMast_Status_id And PDH.iCompany_id=MSR.iCompany_id 
				And PDH.iDoc_Template_id=MSR.iDoc_Template_id and MSR.bActive=1        
			Left Join ASTIL_Admin.dbo.Mast_Company_info MCIR On MCIR.iCompany_id=MSR.iCompany_id_Res        
			Left Join Mast_Sub_Category MSC ON MSC.iMast_Sub_Category_Id=PDH.iMast_Sub_Category_Id        
			where PDH.bActive=1  and PDH.iDoc_Template_id='       
			+ cast(@iDoc_Template_id AS VARCHAR(50)) + ' and (isnull(''' + convert(VARCHAR(10), @FromDate, 121) + ''' ,'''')=''''
			OR (convert(varchar(10),PDH.dProperty_Doc_dt,121) between ''' + convert(VARCHAR(10), @FromDate, 121) + ''' 
			AND  ''' + convert(VARCHAR(10), @Todate, 121) + ''' )) AND (' + cast(@companyid AS VARCHAR) + ' = 0 
			OR PDH.iCompany_id= ' + cast(@companyid AS VARCHAR) + ') AND (' + cast(@companyid AS VARCHAR) + '= 0 
			OR (isnull(''' + CAST(@status AS VARCHAR) + ''','''')='''' OR PDH.bStatus in(SELECT Items FROM  Split(''' + 
			CAST(@status AS VARCHAR) + ''','','')))) and PDH.bStatus not in (Select Distinct MSS.iMast_Status_id 
			From Mast_Status_View_Restrict MVR 
			Inner Join Mast_Status_Rights MSS ON MSS.iMast_Status_Rights_Id=MVR.iMast_Status_Rights_Id 
			inner join ASTIL_Admin..Mast_Users MU on MVR.iViewRestrict_Role_Type_id=MU.bSuperUser 
			Where MVR.bActive=1  and MSS.bActive=1 and 
			MU.iUser_id=' + cast(@Userid AS VARCHAR) + ' and MSS.iDoc_Template_id=DT.iDoc_Template_id)        
		) p Where iDoc_Template_id=' + cast(@iDoc_Template_id as varchar(50))
		--+ ' AND RowNum = 1'          
		PRINT @query            
		EXEC (@query) 
	end
end
