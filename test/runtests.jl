@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

using REDCap


# -=: Test: Functionality :=- #
@testset "Full Functionality" begin
	#setup for any needed vars
	println("Creating Config Object")
	super_config = ""
	config = ""
	full_test=false
	#Get keys from user environment
	api_url=get(ENV, "REDCAP_URL", "")
	if length(api_url)>0
		super_key=get(ENV, "REDCAP_SUPER_API", "")
		if length(super_key)>0
			full_test=true
			global super_config = REDCap.Config(api_url, super_key)
		else
			@warn("Cannot find REDCap Super API key in environment.")
			key=get(ENV, "REDCAP_API", "")
			if length(key)>0
				global config = REDCap.Config(api_url, key)
			else
				@error("Cannot find REDCap API key in environment.")
			end
		end
	else
		@error("Cannot find REDCap URL in environment.")	
	end	

	#=	TESTING:
	# needs to be able to manipulate a project, and verify what comes back. Create project in users environment? Dedicated test env?
	# Must: Create, Import, Export, make sure what you put in is what you got out, and delete everything properly.
	# Create: make a project from scratch using stock settings
	# Import: Make (and save) a bunch of generic constructions for fields, metadata, records, everything that can be imported- 
	# 	After, lock the project/make it as 'out of development' and try to re-import everything that-
	#	should be blocked once out of dev in REDCap.
	# Export: grab everything from the project and verify it matches the generated data perfectly- 
	#	also check any files and the pdf and xml of project.
	# Delete: Delete everything from the project piece by piece, and finally the project-
	# 	Verify everything, and try to export from it again.
	#
	# Have a file that contains ~40 example records, and all testing data needed? Not include generators? Space vs. complexity
	# 
	=#
	if full_test
		println("Creating Project")
		#Creating
		config = create_project(super_config, "Test Project", 1; purpose_other="Testing REDCap.jl Functionality", project_notes="This is not an actual REDCap Database.", is_longitudinal=1, surveys_enabled=1, record_autonumbering_enabled=1)
	end

	#=
	create_project(config::REDCap.Config, project_title::String, purpose::Integer; format::String="json", returnFormat::String="json", odm="", purpose_other::String="", project_notes::String="", is_longitudinal::Integer=0, surveys_enabled::Integer=0, record_autonumbering_enabled::Integer=1)
	=#

	#Importing- 
	#stock records
	stock_records=[Dict{String, String}("sex" => "1",
					  "age" => "56",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "180",
					  "dob" => "1962-07-30",
					  "record_id" => "1",
					  "bmi" => "24.7",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "JSmith@aol.com",
					  "first_name" => "John",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict{String, String}("sex" => "1",
					  "age" => "16",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "180",
					  "dob" => "2002-07-30",
					  "record_id" => "2",
					  "bmi" => "24.7",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "M_Smith@aol.com",
					  "first_name" => "Matthew",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict{String, String}("sex" => "0",
					  "age" => "20",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "180",
					  "dob" => "1998-07-30",
					  "record_id" => "3",
					  "bmi" => "24.7",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "MJ_Smith@aol.com",
					  "first_name" => "Mary",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1"),
					Dict{String, String}("sex" => "0",
					  "age" => "46",
					  "address" => "168 Anderson Blvd. Quincy MA 01227",
					  "height" => "180",
					  "dob" => "1972-07-30",
					  "record_id" => "4",
					  "bmi" => "24.7",
					  "comments" => "Randomly Generated - Demographics",
					  "email" => "L_Smith@aol.com",
					  "first_name" => "Lisa",
					  "demographics_complete" => "0",
					  "telephone" => "(617) 882-6049",
					  "weight" => "80",
					  "last_name" => "Smith",
					  "ethnicity" => "1",
					  "race"  => "1")]

	println("Initial Import Records Test")
	@test import_records(config, stock_records)["count"] == length(stock_records)

	stock_user=[Dict{String, Any}("username" => "john_smith@email.com",
					"email" => "john_smith@email.com",
                    "design" => "1",
                    "api_export" => "1",
                    "user_rights" => "1",
                    "data_access_groups" => "0",
                    "data_comparison_tool" => "0",
                    "data_access_group_id" => "",
                    "data_export" => "1",
                    "record_create" => "1",
                    "reports" => "1",
                    "data_import_tool" => "1",
                    "file_repository" => "0",
                    "mobile_app_download_data" => "1",
                    "mobile_app" => "1",
                    "data_quality_create" => "1",
                    "record_delete" => "1",
                    "calendar" => "1",
                    "lock_records_all_forms" => "1",
                    "firstname" => "John",
                    "expiration" => "",
                    "data_access_group" => "",
                    "api_import" => "1",
                    "stats_and_charts" => "1",
                    "record_rename" => "1",
                    "lock_records_customization" => "1",
                    "logging" => "1",
                    "lock_records" => "1",
                    "data_quality_execute" => "1",
                    "manage_survey_participants" => "1",
                    "forms" => Dict{String,Any}("demographics"=>"0","visit_form"=>"0"),
					"lastname" => "Smith")]

	println("Initial Import Users Test")
	@test import_users(config, stock_user) == 1

	println("Initial Import Project Info Test")
	stock_proj_info=Dict{String, String}("project_title" => "RC Test",
						 "project_notes" => "testing")
	result = import_project_information(config, stock_proj_info)
	@test (result == length(stock_proj_info)) || (result == 23) #either the changed or all values idk...

	println("Initial Import Arms Test")
	#Import arms and events here, along with inst-event-mappings
    stock_arms=[Dict{String, String}("name" => "Arm 2",
                    "arm_num" => "2")] #verify this
    @test import_arms(config, stock_arms) == 1

    println("Initial Import Events Test")
    stock_events=[Dict{String, Any}("unique_event_name" => "event_1_arm_2",
                      "custom_event_label" => nothing,
                      "offset_max" => "0",
                      "arm_num" => "2",
                      "event_name" => "Event 1",
                      "day_offset" => "1",
                      "offset_min" => "0")]
    @test import_events(config, stock_events) == 1

	#Exporting - verify that data exported is accurate and in there(?)
	#Call functions in more varietyies of ways - show off options - export to file, verifiy file is there and can 
	#be grabbed, modified, and re-imported
	println("Batch Testing-")
	modules = [:(export_field_names(config)),
				:(export_records(config, format="csv")),
				:(export_records(config, format="xml")),
				:(export_records(config, format="odm")),
				:(export_records(config, format="df")),
				:(export_records(config, fields=["record_id","first_name"])),
				:(export_metadata(config)),
				:(export_version(config)),
				:(export_pdf(config, "export.pdf")),
				:(export_project(config))]
	for m in modules
		println(m)
		try #use carefully!
			eval(m)
			@test true
		catch
			println("Failed - $m")
			@test false
		end
	end

	println("Records Validation")
	testing_records = export_records(config, rawOrLabel="raw")
    #for loop here to run through all of them?
    for (i, item) in enumerate(testing_records)
    	for (k,v) in item
    		@test v == stock_records[i][k]
    	end
    end

    println("Records I/O Test")
    #File I/O
    export_records(config, file_loc="records.txt")
    @test import_records(config, "records.txt")["count"] == length(stock_records)

    #testing_user = export_users(config)
    #Test to ensure user matches stock - all settings transfer
    #for (k, v) in testing_user[end]
    #    @test testing_user[end][k] == stock_user[1][k]
    #end
    println("Project Info Verification")
    testing_info = export_project_information(config)
    @test testing_info["project_notes"] == stock_proj_info["project_notes"]
    @test testing_info["project_title"] == stock_proj_info["project_title"]

###TODO
    #testing_arms = export_arms(config)
    #Verify arm is there - can check for 2 arms?

    #testing_events = export_events(config)
	ex_info = export_project_information(config)
    #verify event there


###TODO
	#testing_mapping = export_instrument_event_mappings(config)
    #change mapping, check again
    new_mapping = Dict("arm_num" => "2",
                        "form" => "demographics",
                        "unique_event_name" => "event_1_arm_2")



    #testing_mapping_again = export_instrument_event_mappings(config)

    #Test modifying user - this may rely on what your permissions are after project creation - will need to test that more
    stock_user_changed=[Dict{String, Any}("username" => "john_smith21@email.com",
        					"email" => "john_smith21@email.com",
                            "design" => "0",
                            "api_export" => "0",
                            "user_rights" => "0",
                            "data_access_groups" => "0",
                            "data_comparison_tool" => "0",
                            "data_access_group_id" => "",
                            "data_export" => "0",
                            "record_create" => "0",
                            "reports" => "0",
                            "data_import_tool" => "0",
                            "file_repository" => "0",
                            "mobile_app_download_data" => "0",
                            "mobile_app" => "0",
                            "data_quality_create" => "0",
                            "record_delete" => "0",
                            "calendar" => "0",
                            "lock_records_all_forms" => "0",
                            "firstname" => "Johnathan",
                            "expiration" => "",
                            "data_access_group" => "",
                            "api_import" => "0",
                            "stats_and_charts" => "0",
                            "record_rename" => "0",
                            "lock_records_customization" => "0",
                            "logging" => "0",
                            "lock_records" => "0",
                            "data_quality_execute" => "0",
                            "manage_survey_participants" => "0",
        					"forms" => Dict{String,Any}("demographics"=>"0","visit_form"=>"0"),
							"lastname" => "Smithy")]

    println("Import User Modification Test")
    @test import_users(config, stock_user_changed) == 1
    #Verify changes made
    testing_user_changed = export_users(config)
    #Test to ensure user matches stock - all settings transfer
    for (k, v) in testing_user_changed[end]
        @test testing_user_changed[end][k] == stock_user_changed[1][k]
    end


	if full_test
		println("Project Finalization Test")
		final_proj_info=Dict{String, String}("project_title" => "RC Production",
						  	 "in_production" => "1")
		import_project_information(config, final_proj_info)

		#Do things to a production project you shouldnt do

		post_meta = Dict{String, String}("required_field"=>"",
						  "section_header"=>"",
						  "matrix_ranking"=>"",
						  "select_choices_or_calculations"=>"",
						  "field_type"=>"file",
						  "field_note"=>"",
						  "form_name"=>"demographics",
						  "matrix_group_name"=>"",
						  "field_label"=>"File Upload",
						  "custom_alignment"=>"",
						  "question_number"=>"",
						  "text_validation_max"=>"",
						  "text_validation_type_or_show_slider_number"=>"",
						  "branching_logic"=>"",
						  "field_annotation"=>"",
						  "identifier"=>"",
						  "text_validation_min"=>"",
						  "field_name"=>"file_upload")
		println("Metadata Post-Finalization Test")
		try
			import_metadata(config, post_meta)
			@test false
		catch
			@test true
		end

		post_project_info = Dict{String, Any}("project_title" => "New Title",
											"purpose" => 3,
											"is_longitudinal" => 1,
											"surveys_enabled" => 1,
											"record_autonumbering_enabled" => 1)
		println("Project Info Post-Finalization Test")
		import_project_information(config, post_project_info)
		try
			import_metadata(config, post_meta)
			@test false
		catch
			@test true
		end
	end

end