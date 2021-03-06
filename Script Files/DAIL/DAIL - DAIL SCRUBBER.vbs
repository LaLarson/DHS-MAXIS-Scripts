'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
'    HOW THE DAIL SCRUBER WORKS:
'
'    This script opens up other script files, using a custom function (run_DAIL_scrubber_script), followed by the path to the script file. It's done this
'      way because there could be hundreds of DAIL messages, and to work all of the combinations into one script would be incredibly tedious and long.
'
'    This script works by moving the message (where the cursor is located) to the top of the screen, and then reading the message text. Whatever the
'      message text says dictates which script loads up.
'--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

'Required for statistical purposes===============================================================================
name_of_script = "DAIL - DAIL SCRUBBER.vbs"
start_time = timer

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

'CONNECTS TO DEFAULT SCREEN
EMConnect ""

'CHECKS TO MAKE SURE THE WORKER IS ON THEIR DAIL
EMReadscreen dail_check, 4, 2, 48
If dail_check <> "DAIL" then script_end_procedure("You are not in your dail. This script will stop.")

'TYPES A "T" TO BRING THE SELECTED MESSAGE TO THE TOP
EMSendKey "t"
transmit

'The following reads the message in full for the end part (which tells the worker which message was selected)
EMReadScreen full_message, 58, 6, 20

'THE FOLLOWING CODES ARE THE INDIVIDUAL MESSAGES. IT READS THE MESSAGE, THEN CALLS A NEW SCRIPT.----------------------------------------------------------------------------------------------------

'Random messages generated from an affiliated case (loads AFFILIATED CASE LOOKUP)
EMReadScreen stat_check, 4, 6, 6
If stat_check = "FS  " or stat_check = "HC  " or stat_check = "GA  " or stat_check = "MSA " or stat_check = "STAT" then call run_from_GitHub(script_repository & "DAIL/DAIL - AFFILIATED CASE LOOKUP.vbs")

'RSDI/BENDEX info received by agency (loads BNDX SCRUBBER)
EMReadScreen BENDEX_check, 47, 6, 30
If BENDEX_check = "BENDEX INFORMATION HAS BEEN STORED - CHECK INFC" then call run_from_GitHub(script_repository & "DAIL/DAIL - BNDX SCRUBBER.vbs")

'CIT/ID has been verified through the SSA (loads CITIZENSHIP VERIFIED)
EMReadScreen CIT_check, 46, 6, 20
If CIT_check = "MEMI:CITIZENSHIP HAS BEEN VERIFIED THROUGH SSA" then call run_from_GitHub(script_repository & "DAIL/DAIL - CITIZENSHIP VERIFIED.vbs")

'CS reports a new employer to the worker (loads CS REPORTED NEW EMPLOYER)
EMReadScreen CS_new_emp_check, 25, 6, 20
If CS_new_emp_check = "CS REPORTED: NEW EMPLOYER" then call run_from_GitHub(script_repository & "DAIL/DAIL - CS REPORTED NEW EMPLOYER.vbs")

'Child support messages (loads CSES PROCESSING)
EMReadScreen CSES_check, 4, 6, 6
If CSES_check = "CSES" then
  EMReadScreen CSES_DISB_check, 4, 6, 20
  If CSES_DISB_check = "DISB" then call run_from_GitHub(script_repository & "DAIL/DAIL - CSES PROCESSING.vbs")
End if

'Disability certification ends in 60 days (loads DISA MESSAGE)
EMReadScreen DISA_check, 58, 6, 20
If DISA_check = "DISABILITY IS ENDING IN 60 DAYS - REVIEW DISABILITY STATUS" then call run_from_GitHub(script_repository & "DAIL/DAIL - DISA MESSAGE.vbs")

'Client can receive an FMED deduction for SNAP (loads FMED DEDUCTION)
EMReadScreen FMED_check, 59, 6, 20
If FMED_check = "MEMBER HAS TURNED 60 - NOTIFY ABOUT POSSIBLE FMED DEDUCTION" then call run_from_GitHub(script_repository & "DAIL/DAIL - FMED DEDUCTION.vbs")

'Remedial care messages. May only happen at COLA (loads LTC - REMEDIAL CARE)
EMReadScreen remedial_care_check, 41, 6, 20
If remedial_care_check = "REF 01 PERSON HAS REMEDIAL CARE DEDUCTION" then call run_from_GitHub(script_repository & "DAIL/DAIL - LTC - REMEDIAL CARE.vbs")

'New HIRE messages, client started a new job (loads NEW HIRE)
EMReadScreen HIRE_check, 15, 6, 20
If HIRE_check = "NEW JOB DETAILS" then call run_from_GitHub(script_repository & "DAIL/DAIL - NEW HIRE.vbs")

'New HIRE messages, client started a new job (loads NEW HIRE)
EMReadScreen HIRE_check, 11, 6, 27
If HIRE_check = "JOB DETAILS" then call run_from_GitHub(script_repository & "DAIL/DAIL - NEW HIRE NDNH.vbs")

'Sends NOMI is DAIL generated by the REVS scrubber (loads SEND NOMI)
EMReadScreen NOMI_check, 11, 6, 20
If NOMI_check = "~*~*~CLIENT" then call run_from_GitHub(script_repository & "DAIL/DAIL - SEND NOMI.vbs")

'SSI info received by agency (loads SDX INFO HAS BEEN STORED)
EMReadScreen SDX_check, 44, 6, 30
If SDX_check = "SDX INFORMATION HAS BEEN STORED - CHECK INFC" then call run_from_GitHub(script_repository & "DAIL/DAIL - SDX INFO HAS BEEN STORED.vbs")

'Student income is ending (loads STUDENT INCOME)
EMReadScreen SCHL_check, 58, 6, 20
If SCHL_check = "STUDENT INCOME HAS ENDED - REVIEW FS AND/OR HC RESULTS/APP" then call run_from_GitHub(script_repository & "DAIL/DAIL - STUDENT INCOME.vbs")

'SSA info received by agency (loads TPQY RESPONSE)
EMReadScreen TPQY_check, 31, 6, 30
If TPQY_check = "TPQY RESPONSE RECEIVED FROM SSA" then call run_from_GitHub(script_repository & "DAIL/DAIL - TPQY RESPONSE.vbs")

'TYMA scrubber for agencies TIKLING TYMA as you go (loads TYMA Scrubber)
EMReadScreen TYMA_check, 23, 6, 20
IF TYMA_check = "~*~CONSIDER SENDING 1ST" THEN call run_from_GitHub(script_repository & "DAIL/DAIL - TYMA SCRUBBER.vbs")
IF TYMA_check = "~*~CONSIDER SENDING 2ND" THEN Call run_from_GitHub(script_repository & "DAIL/DAIL - TYMA SCRUBBER.vbs")
IF TYMA_check = "~*~2ND QUARTERLY REPORT" THEN call run_from_GitHub(script_repository & "DAIL/DAIL - TYMA SCRUBBER.vbs")
IF TYMA_check = "~*~CONSIDER SENDING 3RD" THEN call run_from_GitHub(script_repository & "DAIL/DAIL - TYMA SCRUBBER.vbs")
IF TYMA_check = "~*~3RD QUARTERLY REPORT" THEN call run_from_GitHub(script_repository & "DAIL/DAIL - TYMA SCRUBBER.vbs")

'FS Eligibility Ending for ABAWD
EMReadScreen ABAWD_elig_end, 32, 6, 20
IF ABAWD_elig_end = "FS ABAWD ELIGIBILITY HAS EXPIRED" THEN CALL run_from_GitHub(script_repository & "DAIL/DAIL - ABAWD FSET EXEMPTION CHECK.vbs")

'NOW IF NO SCRIPT HAS BEEN WRITTEN FOR IT, THE DAIL SCRUBBER STOPS AND GENERATES A MESSAGE TO THE WORKER.----------------------------------------------------------------------------------------------------
script_end_procedure("You are not on a supported DAIL message. The script will now stop. " & vbNewLine & vbNewLine & "The message reads: " & full_message)
