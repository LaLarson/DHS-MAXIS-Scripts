'Created by Tim DeLong from Stearns County.

'Required for statistical purposes==========================================================================================
name_of_script = "NOTES - CHANGE REPORTED.vbs"
start_time = timer
STATS_counter = 1                     	'sets the stats counter at one
STATS_manualtime = 150                	'manual run time in seconds - INCLUDES A POLICY LOOKUP
STATS_denomination = "C"       		'C is for each CASE
'END OF stats block=========================================================================================================

'LOADING FUNCTIONS LIBRARY FROM GITHUB REPOSITORY===========================================================================
IF IsEmpty(FuncLib_URL) = TRUE THEN	'Shouldn't load FuncLib if it already loaded once
	IF run_locally = FALSE or run_locally = "" THEN	   'If the scripts are set to run locally, it skips this and uses an FSO below.
		IF use_master_branch = TRUE THEN			   'If the default_directory is C:\DHS-MAXIS-Scripts\Script Files, you're probably a scriptwriter and should use the master branch.
			FuncLib_URL = "https://raw.githubusercontent.com/MN-Script-Team/BZS-FuncLib/master/MASTER%20FUNCTIONS%20LIBRARY.vbs"
		Else											'Everyone else should use the release branch.
			FuncLib_URL = "https://raw.githubusercontent.com/MN-Script-Team/BZS-FuncLib/RELEASE/MASTER%20FUNCTIONS%20LIBRARY.vbs"
		End if
		SET req = CreateObject("Msxml2.XMLHttp.6.0")				'Creates an object to get a FuncLib_URL
		req.open "GET", FuncLib_URL, FALSE							'Attempts to open the FuncLib_URL
		req.send													'Sends request
		IF req.Status = 200 THEN									'200 means great success
			Set fso = CreateObject("Scripting.FileSystemObject")	'Creates an FSO
			Execute req.responseText								'Executes the script code
		ELSE														'Error message
			critical_error_msgbox = MsgBox ("Something has gone wrong. The Functions Library code stored on GitHub was not able to be reached." & vbNewLine & vbNewLine &_
                                            "FuncLib URL: " & FuncLib_URL & vbNewLine & vbNewLine &_
                                            "The script has stopped. Please check your Internet connection. Consult a scripts administrator with any questions.", _
                                            vbOKonly + vbCritical, "BlueZone Scripts Critical Error")
            StopScript
		END IF
	ELSE
		FuncLib_URL = "C:\BZS-FuncLib\MASTER FUNCTIONS LIBRARY.vbs"
		Set run_another_script_fso = CreateObject("Scripting.FileSystemObject")
		Set fso_command = run_another_script_fso.OpenTextFile(FuncLib_URL)
		text_from_the_other_script = fso_command.ReadAll
		fso_command.Close
		Execute text_from_the_other_script
	END IF
END IF
'END FUNCTIONS LIBRARY BLOCK================================================================================================

'Initial Dialog Box
BeginDialog change_reported_dialog, 0, 0, 171, 105, "Change Reported"
  ButtonGroup ButtonPressed
    OkButton 5, 85, 50, 15
    CancelButton 115, 85, 50, 15
  EditBox 85, 5, 60, 15, MAXIS_case_number
  EditBox 85, 25, 30, 15, MAXIS_footer_month
  EditBox 125, 25, 30, 15, MAXIS_footer_year
  DropListBox 25, 65, 125, 15, "Select One"+chr(9)+"Baby Born"+chr(9)+"HHLD Comp Change", List1
  Text 30, 10, 50, 10, "Case number:"
  Text 15, 30, 65, 10, "Footer month/year: "
  Text 25, 50, 130, 10, "Please select the nature of the change."
EndDialog

BeginDialog baby_born_dialog, 0, 0, 211, 310, "BABY BORN"
  EditBox 55, 5, 95, 15, MAXIS_case_number
  EditBox 55, 25, 95, 15, babys_name
  EditBox 55, 45, 95, 15, date_of_birth
  DropListBox 85, 70, 70, 15, "Select One"+chr(9)+"Yes"+chr(9)+"No", father_in_household
  EditBox 70, 90, 85, 15, fathers_name
  EditBox 70, 115, 85, 15, fathers_employer
  EditBox 70, 140, 85, 15, mothers_employer
  DropListBox 80, 165, 70, 15, "Select One"+chr(9)+"Yes"+chr(9)+"No", other_health_insurance
  EditBox 115, 190, 80, 15, OHI_source
  EditBox 60, 215, 105, 15, other_notes
  EditBox 60, 235, 105, 15, actions_taken
  CheckBox 20, 255, 165, 10, "Newborns MHC plan updated to mothers carrier.", MHC_plan_checkbox
  EditBox 155, 270, 40, 15, worker_signature
  ButtonGroup ButtonPressed
    OkButton 5, 290, 50, 15
    CancelButton 155, 290, 50, 15
  Text 5, 70, 75, 15, "Father In Household?"
  Text 5, 115, 65, 15, "Father's Employer:"
  Text 5, 140, 65, 10, "Mother's Employer: "
  Text 55, 165, 20, 10, "OHI?"
  Text 5, 195, 110, 15, "If yes to OHI, source of the OHI:"
  Text 10, 220, 45, 15, "Other Notes:"
  Text 5, 240, 50, 15, "Actions Taken:"
  Text 90, 275, 65, 15, "Worker Signature:"
  Text 5, 45, 45, 15, "Date of Birth:"
  Text 20, 90, 50, 10, "Fathers Name:"
  Text 5, 5, 50, 15, "Case Number: "
  Text 5, 25, 50, 15, "Baby's Name:"
EndDialog



BeginDialog HHLD_Comp_Change_Dialog, 0, 0, 291, 175, "Household Comp Change"
  Text 5, 15, 50, 10, "Case Number"
  EditBox 60, 10, 100, 15, MAXIS_case_number
  Text 5, 35, 80, 10, "Unit Member HH Change"
  EditBox 90, 30, 45, 15, HH_member
  Text 5, 55, 85, 10, "Date Reported/Addendum"
  EditBox 95, 50, 60, 15, date_reported
  Text 165, 55, 45, 10, "Effective Date"
  EditBox 215, 50, 70, 15, effective_date
  CheckBox 110, 70, 110, 10, "Check if the change is temporary.", temporary_change_checkbox
  Text 10, 90, 45, 10, "Action Taken"
  EditBox 60, 85, 225, 15, actions_taken
  Text 5, 110, 60, 10, "Additional Notes"
  EditBox 60, 105, 225, 15, additional_notes
  Text 10, 130, 45, 15, "Worker Name"
  EditBox 60, 125, 100, 15, worker_signature
  ButtonGroup ButtonPressed
    OkButton 15, 150, 50, 15
    CancelButton 230, 150, 50, 15
EndDialog

'Connecting to BlueZone
EMConnect ""

'Finds the case number
Call MAXIS_case_number_finder(MAXIS_case_number)

'Finds the benefit month
EMReadScreen on_SELF, 4, 2, 50
IF on_SELF = "SELF" THEN
	CALL find_variable("Benefit Period (MM YY): ", MAXIS_footer_month, 2)
	IF MAXIS_footer_month <> "" THEN CALL find_variable("Benefit Period (MM YY): " & MAXIS_footer_month & " ", MAXIS_footer_year, 2)
ELSE
	CALL find_variable("Month: ", MAXIS_footer_month, 2)
	IF MAXIS_footer_month <> "" THEN CALL find_variable("Month: " & MAXIS_footer_month & " ", MAXIS_footer_year, 2)
END IF


'Info to the user of what this script currently covers
MsgBox "This script currently only covers if there is a HHLD Comp Change or a Baby Born. Other reported changes will be covered here in the future."


check_for_maxis(False)

DO
	err_msg = ""
	DIALOG change_reported_dialog
		IF ButtonPressed = 0 THEN stopscript
		IF MAXIS_case_number = "" OR (MAXIS_case_number <> "" AND len(MAXIS_case_number) > 8) OR (MAXIS_case_number <> "" AND IsNumeric(MAXIS_case_number) = False) THEN err_msg = err_msg & vbCr & "* Please enter a valid case number."
		IF List1 = "Select One" THEN err_msg = err_msg & vbCr & "* Please select the type of change reported."
		IF err_msg <> "" THEN MsgBox "*** NOTICE!!! ***" & vbCr & err_msg & vbCr & vbCr & "Please resolve for the script to continue."		
LOOP UNTIL err_msg = ""


IF List1 = "Baby Born" THEN 

'Do loop for Baby Born Dialogbox
DO
	DO
		err_msg = ""
		DIALOG Baby_Born_Dialog
		cancel_confirmation
		IF MAXIS_case_number = "" THEN err_msg = "You must enter case number!"
		IF babys_name = "" THEN err_msg = err_msg & vbNewLine &  "You must enter the babys name"
		IF date_of_birth = "" THEN err_msg = err_msg & vbNewLine &  "You must enter a birth date"
		IF fathers_name = "" THEN err_msg = err_msg & vbNewLine &  "You must enter Father's name"
		IF actions_taken = "" THEN err_msg = err_msg & vbNewLine & "You must enter the actions taken"
		IF worker_signature = "" THEN err_msg = err_msg & vbNewLine & "Please sign your note"
		IF err_msg <> "" THEN msgbox "*** Notice!!! ***" & vbNewLine & err_msg
	LOOP UNTIL err_msg = ""
	call check_for_password(are_we_passworded_out)  'Adding functionality for MAXIS v.6 Passworded Out issue'
LOOP UNTIL are_we_passworded_out = false

END IF

IF List1 = "HHLD Comp Change" THEN

'Do loop for HHLD Comp Change Dialogbox
DO
	DO
		err_msg = ""
		DIALOG HHLD_Comp_Change_Dialog
		cancel_confirmation
		IF MAXIS_case_number = "" THEN err_msg = "You must enter case number!"
		IF HH_Member = "" THEN err_msg = err_msg & vbNewLine & "You must enter a HH Member"
		IF date_reported = "" THEN err_msg = err_msg & vbNewLine & "You must enter date reported"
		IF effective_date = "" THEN err_msg = err_msg & vbNewLine & "You must enter effective date"
		IF actions_taken = "" THEN err_msg = err_msg & vbNewLine & "You must enter the actions taken"
		IF worker_signature = "" THEN err_msg = err_msg & vbNewLine & "Please sign your note"
		IF err_msg <> "" THEN msgbox "*** Notice!!! ***" & vbNewLine & err_msg
	LOOP UNTIL err_msg = ""
	call check_for_password(are_we_passworded_out)  'Adding functionality for MAXIS v.6 Passworded Out issue'
LOOP UNTIL are_we_passworded_out = false

	
END IF


'Checks MAXIS for password prompt
CALL check_for_MAXIS(false)

'Navigates to case note
CALL navigate_to_MAXIS_screen("CASE", "NOTE")

'Send PF9 to case note
PF9


'writes case note for Baby Born
IF List1 = "Baby Born" THEN

	CALL write_variable_in_Case_Note("--Client reports birth of baby--")
	CALL write_bullet_and_variable_in_Case_Note("Baby's name", babys_name)	
	CALL write_bullet_and_variable_in_Case_Note("Date of birth", date_of_birth)
	CALL write_bullet_and_variable_in_Case_Note("Father's name", fathers_name)
	CALL write_bullet_and_variable_in_Case_Note("Father's employer", fathers_employer)
	CALL write_bullet_and_variable_in_Case_Note("Mother's employer", mothers_employer)
	IF OHI_Checkbox = 1 THEN CALL write_bullet_and_variable_in_Case_Note("OHI", OHI_Source)
	IF MHC_plan_checkbox = 1 THEN CALL write_variable_in_CASE_NOTE("* Newborns MHC plan updated to match the mothers.")
	CALL write_bullet_and_variable_in_Case_Note("Other Notes", other_notes)
	CALL write_bullet_and_variable_in_Case_Note("Actions Taken", actions_taken)
	CALL write_bullet_and_variable_in_Case_Note("Additional Notes", additional_notes)
END IF

'writes case note for HHLD Comp Change
IF List1 = "HHLD Comp Change" THEN

	CALL write_variable_in_case_note("HH Comp Change Reported")
	CALL write_bullet_and_variable_in_Case_Note("Unit member HH Member", HH_Member)
	CALL write_bullet_and_variable_in_Case_Note("Date Reported/Addendum", date_reported)
	CALL write_bullet_and_variable_in_Case_Note("Date Effective", effective_date)
	CALL write_bullet_and_variable_in_Case_Note("Actions Taken", actions_taken)
	CALL write_bullet_and_variable_in_Case_Note("Additional Notes", additional_notes)

	'case notes if the change is temporary
	IF Temporary_Change_Checkbox = 1 THEN CALL write_variable_in_Case_Note("***Change is temporary***")
	IF Temporary_Change_Checkbox = 0 THEN CALL write_variable_in_Case_Note("***Change is NOT temporary***")

END IF

'signs case note
CALL write_variable_in_Case_Note("----")
CALL write_variable_in_Case_Note(worker_signature)

script_end_procedure ("")
