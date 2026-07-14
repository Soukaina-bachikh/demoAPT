// Populates the database with sample data for testing. Safe to re-run: clears
// existing data (after confirmation) before reloading a fresh sample set.

#DECLARE()

CONFIRM("This will delete all existing data and reload sample data. Continue?"; "Yes"; "No")
If (OK#1)
	return
End if

ds.Conversation.all().drop()
ds.Appointment.all().drop()
ds.Availability.all().drop()
ds.Client.all().drop()
ds.Staff.all().drop()

var $s1ID; $s2ID; $s3ID : Text
var $c1ID; $c2ID; $c3ID; $c4ID : Text
var $day : Integer

var $staff1 : cs.StaffEntity
$s1ID:=Generate UUID
$staff1:=ds.Staff.new()
$staff1.staffID:=$s1ID
$staff1.firstName:="Jean"
$staff1.lastName:="Martin"
$staff1.specialty:="Cardiology"
$staff1.email:="j.martin@clinic.com"
$staff1.phone:="+33 1 23 45 67 89"
$staff1.slotDuration:=30
$staff1.isActive:=True
$staff1.save()

var $staff2 : cs.StaffEntity
$s2ID:=Generate UUID
$staff2:=ds.Staff.new()
$staff2.staffID:=$s2ID
$staff2.firstName:="Claire"
$staff2.lastName:="Bernard"
$staff2.specialty:="General Medicine"
$staff2.email:="c.bernard@clinic.com"
$staff2.phone:="+33 1 23 45 67 90"
$staff2.slotDuration:=20
$staff2.isActive:=True
$staff2.save()

var $staff3 : cs.StaffEntity
$s3ID:=Generate UUID
$staff3:=ds.Staff.new()
$staff3.staffID:=$s3ID
$staff3.firstName:="Paul"
$staff3.lastName:="Dupuis"
$staff3.specialty:="Support"
$staff3.email:="p.dupuis@clinic.com"
$staff3.phone:="+33 1 23 45 67 91"
$staff3.slotDuration:=15
$staff3.isActive:=True
$staff3.save()

// Monday(1) through Friday(5), 09:00-17:00 for each staff member
For ($day; 1; 5)
	var $avail1 : cs.AvailabilityEntity
	$avail1:=ds.Availability.new()
	$avail1.availabilityID:=Generate UUID
	$avail1.staffID:=$s1ID
	$avail1.dayOfWeek:=$day
	$avail1.startTime:=Time("09:00:00")
	$avail1.endTime:=Time("17:00:00")
	$avail1.save()

	var $avail2 : cs.AvailabilityEntity
	$avail2:=ds.Availability.new()
	$avail2.availabilityID:=Generate UUID
	$avail2.staffID:=$s2ID
	$avail2.dayOfWeek:=$day
	$avail2.startTime:=Time("09:00:00")
	$avail2.endTime:=Time("17:00:00")
	$avail2.save()

	var $avail3 : cs.AvailabilityEntity
	$avail3:=ds.Availability.new()
	$avail3.availabilityID:=Generate UUID
	$avail3.staffID:=$s3ID
	$avail3.dayOfWeek:=$day
	$avail3.startTime:=Time("09:00:00")
	$avail3.endTime:=Time("17:00:00")
	$avail3.save()
End for

var $client1 : cs.ClientEntity
$c1ID:=Generate UUID
$client1:=ds.Client.new()
$client1.clientID:=$c1ID
$client1.firstName:="Marie"
$client1.lastName:="Dupont"
$client1.email:="marie.dupont@example.com"
$client1.phone:="+33 6 12 34 56 78"
$client1.createdAt:=Current date
$client1.save()

var $client2 : cs.ClientEntity
$c2ID:=Generate UUID
$client2:=ds.Client.new()
$client2.clientID:=$c2ID
$client2.firstName:="Thomas"
$client2.lastName:="Leroy"
$client2.email:="thomas.leroy@example.com"
$client2.phone:="+33 6 98 76 54 32"
$client2.createdAt:=Current date
$client2.save()

var $client3 : cs.ClientEntity
$c3ID:=Generate UUID
$client3:=ds.Client.new()
$client3.clientID:=$c3ID
$client3.firstName:="Nathalie"
$client3.lastName:="Rousseau"
$client3.email:="nathalie.rousseau@example.com"
$client3.phone:="+33 6 11 22 33 44"
$client3.createdAt:=Current date
$client3.save()

var $client4 : cs.ClientEntity
$c4ID:=Generate UUID
$client4:=ds.Client.new()
$client4.clientID:=$c4ID
$client4.firstName:="Antoine"
$client4.lastName:="Moreau"
$client4.email:="antoine.moreau@example.com"
$client4.phone:="+33 6 55 66 77 88"
$client4.createdAt:=Current date
$client4.save()

var $appointments : Collection
$appointments:=[\
	{code: "APT-DEMO01"; clientID: $c1ID; staffID: $s1ID; date: Current date+3;  time: "14:30:00"; duration: $staff1.slotDuration; reason: "Routine check-up";           status: "confirmed"};\
	{code: "APT-DEMO02"; clientID: $c2ID; staffID: $s2ID; date: Current date+1;  time: "09:00:00"; duration: $staff2.slotDuration; reason: "Annual physical";            status: "confirmed"};\
	{code: "APT-DEMO03"; clientID: $c3ID; staffID: $s3ID; date: Current date+5;  time: "11:00:00"; duration: $staff3.slotDuration; reason: "Equipment support";         status: "confirmed"};\
	{code: "APT-DEMO04"; clientID: $c4ID; staffID: $s1ID; date: Current date+7;  time: "15:30:00"; duration: $staff1.slotDuration; reason: "Follow-up consultation";     status: "confirmed"};\
	{code: "APT-DEMO05"; clientID: $c1ID; staffID: $s2ID; date: Current date-4;  time: "10:00:00"; duration: $staff2.slotDuration; reason: "Flu symptoms";               status: "confirmed"};\
	{code: "APT-DEMO06"; clientID: $c2ID; staffID: $s1ID; date: Current date-10; time: "16:00:00"; duration: $staff1.slotDuration; reason: "Cardiology consultation";    status: "confirmed"};\
	{code: "APT-DEMO07"; clientID: $c4ID; staffID: $s3ID; date: Current date-2;  time: "13:00:00"; duration: $staff3.slotDuration; reason: "Support request";            status: "cancelled"};\
	{code: "APT-DEMO08"; clientID: $c3ID; staffID: $s2ID; date: Current date+2;  time: "09:30:00"; duration: $staff2.slotDuration; reason: "Rescheduled by client";      status: "cancelled"}\
]

var $apptData : Object
For each ($apptData; $appointments)
	var $appt : cs.AppointmentEntity
	$appt:=ds.Appointment.new()
	$appt.appointmentID:=Generate UUID
	$appt.confirmationCode:=$apptData.code
	$appt.clientID:=$apptData.clientID
	$appt.staffID:=$apptData.staffID
	$appt.date:=$apptData.date
	$appt.time:=Time($apptData.time)
	$appt.duration:=$apptData.duration
	$appt.reason:=$apptData.reason
	$appt.status:=$apptData.status
	$appt.createdAt:=Current date
	$appt.save()
End for each

ALERT("Seed complete! Staff: 3 | Clients: 4 | Appointments: "+String($appointments.length))
