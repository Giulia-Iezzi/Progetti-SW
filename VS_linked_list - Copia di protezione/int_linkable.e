note
	description: "Summary description for {INT_LINKABLE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	INT_LINKABLE

create
	make

feature

	value: INTEGER
			-- the integer stored in this cell
			-- commento aggiunto per prova

	set_value (new_value: INTEGER)
			-- assign the integer stored in this cell
		do
			value := new_value
		ensure
			value = new_value
		end

	next: detachable INT_LINKABLE
			-- the next cell in the list

	make (a_value: INTEGER)
			-- create this cell
		do
			value := a_value
		ensure
			value = a_value
		end

	link_to (other: detachable INT_LINKABLE)
			-- connect this cell to `other'
		do
			next := other
		ensure
			next = other
		end

	link_after (other: detachable INT_LINKABLE)
			-- insert this cell after `other' preserving what was after it
		require
			other /= Void
		do
			check attached other as o then
				link_to (o.next)
				o.link_to (Current)
			end
		ensure
			other /= Void
			other.next = Current
			attached other.next as on implies (on.next = old other.next)
		end

end
