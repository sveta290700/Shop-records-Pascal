program shops;

const
  N = 9;

type
  ShopName = string[20];
  ProductName = string[20];
  DataType = record
    shop: ShopName;
    product: ProductName;
    kol: 0..100;
  end;
  DataMas = array [1..N] of DataType;
  RussianBig = set of char;
  RussianSmall = set of char;

var
  DataAll: DataMas;
  were: set of ProductName;
  shopset: set of ShopName;
  shopkol, infokol, i, j, z, cost, shopcount, zadanie, tempcount: integer;
  input, output: text;
  error: boolean;
  s: string;
  tempShop: ShopName;
  tempproduct: ProductName;
  RussianBigSet: RussianBig;
  RussianSmallSet: RussianSmall;

procedure Correct(var fail: text; infokoll: integer);
var
  k: integer;
  s: string;
begin
  reset(fail);
  k := 0;
  while not eof(fail) do 
  begin
    readln(fail, s);
    k := k + 1;
  end;
  if infokoll <> k - 1 then error := true;
end;

function Convert(s: string): integer;
var
  i, n: integer;
begin
  n := 0;
  for i := 1 to length(s) do
    if s[i] in ['0'..'9'] then begin
      n := 10 * n + Ord(s[i]) - Ord('0');
      if (not (s[i] in ['0'..'9'])) and (s[i] <> '-') then error := true;
    end;
  if s[1] = '-' then n := n * (-1);
  if error <> true then convert := n else convert := -1;
end;

procedure CorrectData(var fail: text);
var
  i, pole: integer;
  s, tempstring, temppole, kolvo: string;
begin
  reset(fail);
  readln(fail);
  pole := 0;
  tempstring := '';
  temppole := '';
  kolvo := '';
  while not eof(fail) and (error = false) do 
  begin
    readln(fail, s);
    tempstring := s;
    i := 1;
    if tempstring = '' then error := true else begin
      while (i < length(s) + 1) and (error = false) do 
      begin
        if pole < 2 then begin
          if tempstring[i] <> ',' then begin
            if not ((tempstring[i] in russianbigset) or (tempstring[i] in russiansmallset)) then error := true;
            temppole := temppole + tempstring[i];
          end
          else begin
            if (temppole = '') then error := true;
            if length(temppole) > 20 then error := true;
            pole := pole + 1;
            temppole := '';
            i := i + 1;
          end;
        end
        else
        if (i < length(tempstring) + 1) and (tempstring[i] in ['0'..'9']) or (tempstring[i] = '-') and (error <> true)  then
          kolvo := kolvo + tempstring[i] else error := true;
        i := i + 1;
      end;
      if kolvo = '' then error := true;
      if (error = false) then
        if (convert(kolvo) < 0) or (convert(kolvo) > 100) then error := true;
      pole := 0;
      tempstring := '';
      kolvo := '';
    end;
  end;
end;

procedure InputData(var fail: text; var DataOne: DataType);
var
  i, j: integer;
  s, empty: string;
begin
  reset(fail);
  for j := 1 to cost do
    readln(fail);
  read(fail, s);
  i := 1;
  empty := '';
  while s[i] <> ',' do 
  begin
    empty := empty + s[i];
    i := i + 1;
  end;
  DataOne.shop := empty;
  empty := '';
  i := i + 2;
  while s[i] <> ',' do 
  begin
    empty := empty + s[i];
    i := i + 1;
  end;
  DataOne.product := empty;
  empty := '';
  i := i + 2;
  while i <> length(s) + 1 do 
  begin
    empty := empty + s[i];
    i := i + 1;
  end;
  DataOne.kol := convert(empty);
  readln(fail);
end;

procedure SortData(var DataAllMas: DataMas);
var
  i, j, k: integer;
  t: DataType;
begin
  j := infokol + 1;
  for i := j - 1 downto 1 do
    for k := 1 to i - 1 do
      if DataAllMas[k].shop > DataAllMas[k + 1].shop then
      begin
        t := DataAllMas[k];
        DataAllMas[k] := DataAllMas[k + 1];
        DataAllMas[k + 1] := t;
      end;
end;

function Equality(temp: string; temp2: string): boolean;
var
  i, l1, l2: integer;
  tempbool: boolean;
begin
  tempbool := true;
  l1 := length(temp);
  l2 := length(temp2);
  if l1 <> l2 then tempbool := false else begin
    for i := 1 to l1 do 
    begin
      if temp[i] <> temp2[i] then tempbool := false;
    end;
  end;
  if tempbool = true then Equality := true else Equality := false;
end;

begin
  assign(input, 'INPUT.txt');
  reset(input);
  assign(output, 'OUTPUT.txt');
  rewrite(output);
  readln(input, s);
  if s <> '' then begin
    if (s[1] in ['0'..'9']) and (s[2] = ' ') and (s[3] in ['0'..'9']) then begin
      reset(input);
      readln(input, infokol, shopkol);
      if (infokol in [1..9]) and (shopkol in [1..9]) then begin
        Correct(input, infokol);
        RussianBigSet := ['А'..'Я'];
        RussianSmallSet := ['а'..'я'];
        CorrectData(input);
        cost := 0;
        if error then writeln(output, 'ОШИБКА') else begin
          for i := 1 to infokol do 
          begin
            cost := cost + 1;
            InputData(input, DataAll[i]);
          end;
          SortData(DataAll);
          for z := 1 to infokol do
            if not (DataAll[z].shop in shopset) then begin
              tempcount := tempcount + 1;
              shopset := shopset + [DataAll[z].shop];
            end;
          if shopkol = tempcount then begin
            writeln('1 - задача А, 2 - задача Б');
            readln(zadanie);
            if zadanie = 1 then begin
              for j := 1 to infokol do 
              begin
                if not (tempproduct in were) then begin
                  tempproduct := DataAll[j].product;
                  for i := 1 to infokol do 
                  begin
                    if (not Equality(tempshop, DataAll[i].shop)) and (Equality(tempproduct, DataAll[i].product)) and (DataAll[i].kol <> 0) then begin
                      shopcount := shopcount + 1;
                      tempshop := DataAll[i].shop;
                    end;
                  end;
                  were := were + [tempproduct];
                  if shopcount = shopkol then
                    writeln(output, DataAll[j].product);
                  shopcount := 0;
                  tempproduct := DataAll[j + 1].product;
                end;
              end;
            end
            else if zadanie = 2 then begin
              for j := 1 to infokol do 
              begin
                if not (tempproduct in were) then begin
                  tempproduct := DataAll[j].product;
                  for i := 1 to infokol do 
                  begin
                    if (not Equality(tempshop, DataAll[i].shop)) and (Equality(tempproduct, DataAll[i].product)) and (DataAll[i].kol = 0) then begin
                      shopcount := shopcount + 1;
                      tempshop := DataAll[i].shop;
                    end;
                  end;
                  were := were + [tempproduct];
                  if shopcount = shopkol then begin
                    writeln(output, DataAll[j].product);
                    shopcount := 0;
                  end;
                  tempproduct := DataAll[j + 1].product;
                end;
              end;
            end
            else writeln(output, 'ОШИБКА');
          end else writeln(output, 'ОШИБКА');
        end;
      end else writeln(output, 'ОШИБКА');
    end else writeln(output, 'ОШИБКА');
  end else writeln(output, 'ОШИБКА');
  close(input);
  close(output);
end.
