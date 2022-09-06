# uxn hello -> hello.rom
function uxn -a input
    uxnasm $input.tal $input.rom && uxnemu $input.rom
end
