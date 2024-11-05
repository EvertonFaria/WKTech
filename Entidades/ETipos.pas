unit ETipos;

interface

type
  // Classe base para tipos estendidos
  TBaseType = class
  private
    FDescricao: string;
    FCampo: string;
  public
    property Descricao: string read FDescricao write FDescricao;
    property Campo: string read FCampo write FCampo;
    procedure Load(pDescricao: string; pCampo: string); virtual;
  end;

  // Classe estendida para strings
  TStringEx = class(TBaseType)
  private
    FValor: string;
  public
    property Valor: string read FValor write FValor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: string);
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: string): TStringEx;
  end;

  // Classe estendida para inteiros
  TIntegerEx = class(TBaseType)
  private
    FValor: Integer;
  public
    property Valor: Integer read FValor write FValor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: Integer); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: Integer): TIntegerEx;
  end;

  // Classe estendida para datas
  TDateEx = class(TBaseType)
  private
    FValor: TDateTime;
  public
    property Valor: TDateTime read FValor write FValor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: TDateTime); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: TDateTime): TDateEx;
  end;

  // Classe estendida para booleanos
  TBooleanEx = class(TBaseType)
  private
    FValor: Boolean;
  public
    property Valor: Boolean read FValor write FValor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: Boolean); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: Boolean): TBooleanEx;
  end;

  // Classe estendida para double
  TDoubleEx = class(TBaseType)
  private
    FValor: Double;
  public
    property Valor: Double read FValor write Fvalor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: Double); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: Double): TDoubleEx;
  end;

  // Classe estendida para double
  TCurrencyEx = class(TBaseType)
  private
    FValor: Currency;
  public
    property Valor: Currency read FValor write Fvalor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: Currency); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: Currency): TCurrencyEx;
  end;

  // Classe estendida para variant
  TVariantEx = class(TBaseType)
  private
    FValor: Variant;
  public
    property Valor: Variant read FValor write Fvalor;
    procedure LoadValor(pDescricao: string; pCampo: string; pValor: Variant); reintroduce;
    class function CriarComValor(const ADescricao: string; ACampo: string; AValor: Variant): TVariantEx;
  end;

implementation

{ TBaseType }

procedure TBaseType.Load(pDescricao: string; pCampo: string);
begin
  FDescricao := pDescricao;
  FCampo := pCampo;
end;

{ TStringEx }

class function TStringEx.CriarComValor(const ADescricao: string; ACampo, AValor: string): TStringEx;
begin
  Result := TStringEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TStringEx.LoadValor(pDescricao: string; pCampo: string; pValor: string);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TDoubleEx }

class function TDoubleEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: Double): TDoubleEx;
begin
  Result := TDoubleEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TDoubleEx.LoadValor(pDescricao: string; pCampo: string; pValor: Double);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TBooleanEx }

class function TBooleanEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: Boolean): TBooleanEx;
begin
  Result := TBooleanEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TBooleanEx.LoadValor(pDescricao: string; pCampo: string; pValor: Boolean);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TDateEx }

class function TDateEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: TDateTime): TDateEx;
begin
  Result := TDateEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TDateEx.LoadValor(pDescricao: string; pCampo: string; pValor: TDateTime);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TIntegerEx }

class function TIntegerEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: Integer): TIntegerEx;
begin
  Result := TIntegerEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TIntegerEx.LoadValor(pDescricao: string; pCampo: string; pValor: Integer);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TVariantEx }

class function TVariantEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: Variant): TVariantEx;
begin
  Result := TVariantEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TVariantEx.LoadValor(pDescricao: string; pCampo: string; pValor: Variant);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

{ TCurrencyEx }

class function TCurrencyEx.CriarComValor(const ADescricao: string; ACampo: string; AValor: Currency): TCurrencyEx;
begin
  Result := TCurrencyEx.Create;
  Result.Descricao := ADescricao;
  Result.Campo := ACampo;
  Result.Valor := AValor;
end;

procedure TCurrencyEx.LoadValor(pDescricao, pCampo: string; pValor: Currency);
begin
  inherited Load(pDescricao, pCampo);
  FValor := pValor;
end;

end.

