function fn_displayInfo(data, update1, update2)
        pos = ceil(data.CurrentPosition);
        update1.Value = pos(2);
        update2.Value = pos(1);
end