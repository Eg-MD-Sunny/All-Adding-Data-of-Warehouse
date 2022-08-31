-----|| 1st Part
-----|| Name: Found SomeThing


SELECT  cast(dbo.ToBdt(sal.CreatedOn) AS smalldatetime) [Auditedon]
		,pv.id											[PVID]
		,pv.Name										[Product]
		,e.BadgeId										[CDBD]
		,e.FullName										[Name]
		,de.DesignationName								[Designation]
		,sal.ActualQuantity								[ActualQty]
		,sal.actionquantity								[ActionQty]
		,sal.CorrectedQuantity							[CorrectedQty]
		,s.WarehouseID									[WarehouseId]
		,w.Name											[Warehouse]

FROM shelfauditLog sal 
join shelf s on s.id=sal.ShelfId
join ProductVariant pv on pv.id=sal.ObservedProductVariantID
join Employee e on e.id=sal.CreatedByEmployeeId
join Warehouse w on w.id=s.WarehouseID
join Designation de on de.id=e.DesignationID

WHERE cast(dbo.ToBdt(sal.CreatedOn) as date)>='2022-08-12'
and cast(dbo.ToBdt(sal.CreatedOn) as date)<'2022-08-19'
and sal.ActionPerformed=34
and de.DesignationName like '%store%'
and w.Id in (26)





-----|| 2nd Part
-----|| Name: Available in Shelve

SELECT max(te.ThingId) MaximumThingId,min(te.ThingId) MinimumThingId
FROM ThingEvent te
JOIN ThingTransaction tt on tt.id = te.ThingTransactionId
WHERE tt.CreatedOn >= '2022-08-12 00:00 +6:00'
AND tt.CreatedOn < '2022-08-19 00:00 +6:00'
AND toState in (256,34359738368)

--#########################################################


select  CAST(dbo.ToBdt(tt.CreatedOn) as date) Date,
        CONCAT(DATEPART(HOUR,dbo.ToBdt(tt.CreatedOn)),':',DATEPART(minute,dbo.ToBdt(tt.CreatedOn))) Time,
        pv.id PVID, pv.name ProductName,
        dbo.tsn(FromState)FromState,
        dbo.tsn(ToState)ToState,
        e.BadgeId, e.FullName, d.DesignationName,
        Count (*) Qty

from ThingTransaction tt
join ThingEvent te on te.ThingTransactionId=tt.id
join Thing t on t.id=te.ThingId
join ProductVariant pv on pv.id=t.ProductVariantId
left join Employee e on tt.CreatedByCustomerId=e.Id
left join Warehouse w on te.WarehouseId=w.Id
left join Designation d on e.DesignationId=d.Id

where   tt.CreatedOn >= '2022-08-12 00:00 +06:00'
and tt.CreatedOn < '2022-08-19 00:00 +06:00'
and toState in (256,34359738368)
and pv.Id in (23334,30605)
and t.id>=33748120 ------ MinimumThingId
and t.id<=161196042 ------ MaximumThingId

Group By    CAST(dbo.ToBdt(tt.CreatedOn) as date) ,
            CONCAT(DATEPART(HOUR,dbo.ToBdt(tt.CreatedOn)),':',DATEPART(minute,dbo.ToBdt(tt.CreatedOn))) ,
            pv.id , pv.name ,
            dbo.tsn(FromState),
            dbo.tsn(ToState),
            e.BadgeId, e.FullName, d.DesignationName, w.Name

Order by 1,2
