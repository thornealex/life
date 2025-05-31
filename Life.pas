program Life;


uses Crt;


const
    LiveCell = Chr(111);
    DeadCell = Chr(32);
    SizeRaster = 47;


type Raster = array [0..SizeRaster, 0..SizeRaster] of Char;


var
    Field, NextField: Raster;
    Line, Column: Integer;


procedure ClearRaster;
begin Write(#27, '[2J') end;


function Tor(Index: Integer): Integer;
begin Tor := (Index + SizeRaster) mod SizeRaster end;


procedure FirstGeneration;
begin for Line := 0 to SizeRaster do ReadLn(Field[Line]) end;


procedure DisplayRaster;
begin for Line := 0 to SizeRaster do WriteLn(Field[Line]) end;


procedure InitRaster(var StartField: Raster);
begin
    for Line := 0 to SizeRaster do
        for Column := 0 to SizeRaster do
            StartField[Line, Column] := DeadCell
end;


function GameLoop: Boolean;
begin GameLoop := True;
    for Line := 0 to SizeRaster do
        for Column := 0 to SizeRaster do
            (* The game ends if,
             * during the next step,
             * none of the cells changes its state. *)
            if Field[Line, Column] <> NextField[Line, Column] then
            begin GameLoop := False;
                Break
            end;
    Field := NextField
end;


function MooresNeighborhood: Integer;
    var X, Y, CellCount: Integer;
begin CellCount := 0;
    for X := Pred(Line) to Succ(Line) do
        for Y := Pred(Column) to Succ(Column) do
            if (X <> Line) or (Y <> Column) then
                (* Calculates the number of living
                 * cells in the Moore neighborhood
                 * of a given cell. *)
                if Field[Tor(X), Tor(Y)] = LiveCell then
                    CellCount := CellCount + 1;
    MooresNeighborhood := CellCount
end;


procedure ApplyRules;
begin
    for Line := 0 to SizeRaster do
        for Column := 0 to SizeRaster do
            (* Each subsequent generation is calculated
             * on the basis of the previous one:
             *
             * in a dead cell, with which three living cells
             * are neighbors, life is born;
             *
             * if a living cell has two or three living neighbors,
             * then this cell continues to live;
             *
             * if there are less than two or more than three
             * living neighbors, the cell dies. *)
            if Field[Line, Column] = DeadCell then
                if MooresNeighborhood = 3 then
                    NextField[Line, Column] := LiveCell
                else NextField[Line, Column] := DeadCell
            else
                if MooresNeighborhood in [2, 3] then
                    NextField[Line, Column] := LiveCell
                else NextField[Line, Column] := DeadCell
end;


begin
    InitRaster(Field);
    InitRaster(NextField);
    FirstGeneration;
    repeat
        DisplayRaster;
        ApplyRules;
        Delay(100);
        ClearRaster;
    until GameLoop
end .
