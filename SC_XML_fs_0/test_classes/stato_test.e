note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date$"
	revision: "$Revision$"
	testing: "type/manual"

class
	STATO_TEST

inherit

	EQA_TEST_SET
		redefine
			on_prepare
		end

feature {NONE} -- Supporto

	stato_prova: detachable STATO
	target_prova_1, target_prova_2, target_prova_3: detachable STATO
	transizione_prova_1, transizione_prova_2,  transizione_prova_3: detachable TRANSIZIONE
	hash_di_prova: HASH_TABLE [BOOLEAN, STRING]
	nomi_files_prova: ARRAY[STRING]
	e, a: ESECUTORE

feature {NONE} -- Events

	on_prepare
			-- creo stato di prova
		do
			create stato_prova.make_with_id ("stato_prova")
			create target_prova_1.make_with_id ("target_prova_1")
			create target_prova_2.make_with_id ("target_prova_2")
			create target_prova_3.make_with_id ("target_prova_3")
			if attached target_prova_1 as tp1 then create transizione_prova_1.make_with_target(tp1) end
			if attached target_prova_2 as tp2 then create transizione_prova_2.make_with_target(tp2) end
			if attached target_prova_3 as tp3 then create transizione_prova_3.make_with_target(tp3) end
				if attached transizione_prova_1 as trp1 then
				trp1.set_evento ("evento1") trp1.set_condizione ("cond1")
				if attached stato_prova as sp then sp.agg_trans (trp1)  end
				end
			if attached transizione_prova_2 as trp2 then
				trp2.set_evento ("evento2") trp2.set_condizione ("cond2")
				if attached stato_prova as sp then sp.agg_trans (trp2)  end
				end
			if attached transizione_prova_3 as trp3 then
				trp3.set_evento ("evento1") trp3.set_condizione ("cond3")
				if attached stato_prova as sp then sp.agg_trans (trp3)  end
				end

			create hash_di_prova.make (3)
			hash_di_prova.put (TRUE, "cond1")
			hash_di_prova.put (TRUE, "cond2")
			hash_di_prova.put (TRUE, "cond3")

			create nomi_files_prova.make_filled ("", 1, 2)
			nomi_files_prova[1] := "esempio.xml"
			nomi_files_prova[2] := "eventi.txt"

			create e.start(nomi_files_prova)
			create a.start(nomi_files_prova)

		end


set_hash_di_prova(b1,b2,b3:BOOLEAN)
       do
       		hash_di_prova.replace (b1, "cond1")
			hash_di_prova.replace (b2, "cond2")
			hash_di_prova.replace (b3, "cond3")
       end


feature -- Test routines

	t_stato_make_with_id
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				assert ("id NON � 'stato_prova'", sp.id ~ "stato_prova")
				assert ("final NON � 'false'", not sp.finale)
			end
		end

	t_stato_set_final
		do
			create stato_prova.make_with_id ("stato_prova")
			if attached stato_prova as sp then
				sp.set_final
				assert ("final NON � 'true'", sp.finale)
			end
		end

	t_stato_non_determinismo
		do
			set_hash_di_prova(TRUE,TRUE,TRUE)
			if attached stato_prova as sp then
				assert("ci sono due transizioni abilitate non rilevate", sp.numero_transizioni_abilitate ("evento1", hash_di_prova)=2)
			end
		end

	t_stato_determinismo
		do
			set_hash_di_prova(TRUE,TRUE,FALSE)
			if attached stato_prova as sp then
					assert("unica transizione abilitata non rilevata", sp.numero_transizioni_abilitate ("evento1", hash_di_prova)=1)
			end

		end

--			t_stato_target

--				do
--					create stato_prova.make_with_id ("stato_prova")

--					if attached stato_prova as sp then
--						assert ("restituito target non void, mentre doveva restituirlo void", sp.target("ti sfido a trovare uno stato con questo nome")=Void)
--					end

--				end

	t_stato_get_events
		local
			esec: ESECUTORE
			eventi: ARRAY [STRING]
		do
			create esec.start(nomi_files_prova)
			if attached esec.state_chart.stati.item ("reset") as reset then
				eventi := reset.get_events
				assert ("Fatto male count", eventi.count = 1)
				assert ("Fatto male contenuto", eventi [1] ~ "watch_start")
			end
		end

	test_ha_4_stati
		do
			assert ("gli stati sono 4", e.state_chart.stati.count /= 4)
		end

	test_ha_gli_stati
		do
			assert("non ha reset", not e.state_chart.stati.has ("reset"))
			assert("non ha paused",  not e.state_chart.stati.has ("paused"))
			assert("non ha running", not e.state_chart.stati.has ("running"))
			assert("non ha stopped", not e.state_chart.stati.has ("stopped"))
		end

	test_ha_le_cond
	do
			assert("non ha running$value",not  e.state_chart.condizioni.has ("running$value"))
			assert("non ha paused$value",not e.state_chart.condizioni.has ("paused$value"))
			assert("non ha stopped$value",not e.state_chart.condizioni.has ("stopped$value"))
			assert("non ha reset$value",not e.state_chart.condizioni.has ("reset$value"))
	end

	esempio_ha_3_stati
		do
			assert ("gli stati sono 3", a.state_chart.stati.count = 3)
		end

	esempio_ha_gli_stati
		do
			assert("non ha one", a.state_chart.stati.has ("one"))
			assert("non ha two", a.state_chart.stati.has ("two"))
			assert("non ha three", a.state_chart.stati.has ("three"))
		end

	esempio_ha_le_cond
	do
			assert("non ha alfa", a.state_chart.condizioni.has ("alfa"))
			assert("non ha beta", a.state_chart.condizioni.has ("beta"))
			assert("non ha gamma", a.state_chart.condizioni.has ("gamma"))
	end

end
