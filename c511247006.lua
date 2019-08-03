--ダーク・キュア
--fixed by MLD
function c511247006.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511247006.target)
	c:RegisterEffect(e1)
	--gain LP
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511247006,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c511247006.rectg)
	e2:SetOperation(c511247006.recop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
end
function c511247006.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c511247006.rectg(e,tp,eg,ep,ev,re,r,rp,0,chkc) end
	if chk==0 then return true end
	local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(EVENT_SPSUMMON_SUCCESS,true)
	if res and c511247006.rectg(e,tp,teg,tep,tev,tre,tr,trp,0) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_RECOVER)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e:SetOperation(c511247006.recop)
		c511247006.rectg(e,tp,teg,tep,tev,tre,tr,trp,1)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c511247006.filter(c,te,re,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==1-tp and (not te or c:IsCanBeEffectTarget(te)) and (not re or c:IsRelateToEffect(re))
end
function c511247006.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and c511247006.filter(chkc,e,nil,tp) end
	if chk==0 then return eg:IsExists(c511247006.filter,1,nil,e,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(80161395,1))
	local g=eg:FilterSelect(tp,c511247006.filter,1,1,nil,e,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,g:GetFirst():GetAttack()/2)
end
function c511247006.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and c511247006.filter(tc,nil,e,tp) then
		Duel.Recover(1-tp,tc:GetAttack()/2,REASON_EFFECT)
	end
end
