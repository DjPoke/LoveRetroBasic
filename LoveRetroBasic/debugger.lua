-- function de retour d'erreurs
function GetError(err_code, err_line)
	local e = "Ok"
	
	if err_code ~= OK then
		if err_code == ERR_OVERFLOW then
			e = "Overflow"
		elseif err_code == ERR_OPERAND_MISSING then
			e = "Operand missing"
		elseif err_code == ERR_TOO_MANY_OPERANDS then
			e = "Too many operands"
		elseif err_code == ERR_TYPE_MISMATCH then
			e = "Type mismatch"
		elseif err_code == ERR_SYNTAX_ERROR then
			e = "Syntax error"
		elseif err_code == ERR_DUPLICATE_LABEL then
			e = "Duplicate label"
		elseif err_code == ERR_UNDEFINED_LABEL then
			e = "Undefined label"
		elseif err_code == ERR_UNKNOWN_COMMAND then
			e = "Unknown commands"
		elseif err_code == ERR_OUT_OF_MEMORY then
			e = "Out of memory"
		elseif err_code == ERR_MEMORY_FULL then
			e = "Memory full"
		elseif err_code == ERR_DIVISION_BY_ZERO then
			e = "Division by zero"
		elseif err_code == ERR_STACK_FULL then
			e = "Stack full"
		elseif err_code == ERR_UNEXPECTED_RETURN then
			e = "Unexpected return"
		elseif err_code == ERR_READ_ERROR then
			e = "Read error"
		elseif err_code == ERR_WRITE_ERROR then
			e = "Write error"
		elseif err_code == ERR_DISC_MISSING then
			e = "Disc missing"
		elseif err_code == ERR_FILE_MISSING then
			e = "File missing"
		end
		
		if err_line ~= nil then
			e = e .. " at line " .. tostring(err_line)
		end
	end
	
	return e
end

-- throw an error and exit
function RuntimeError(e)
	love.window.showMessageBox("Runtime Error", e, "error", true)
	love.event.quit(1)
end