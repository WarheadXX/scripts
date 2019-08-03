--Fusionist Copycat
function c5412761.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(57421866,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c5412761.target)
	e1:SetOperation(c5412761.operation)
	c:RegisterEffect(e1)
	--cos
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(89312388,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCountLimit(1)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c5412761.coscost)
	e2:SetOperation(c5412761.cosoperation)
	c:RegisterEffect(e2)
end

function c5412761.filter(c)
	return c:IsFaceup() and c:GetLevel()>=2
end
function c5412761.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c5412761.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingTarget(c5412761.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c5412761.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(57421866,1))
	local g=Duel.SelectMatchingCard(tp,c5412761.filter,tp,LOCATION_MZONE,0,1,1,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(tc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(-1)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c5412761.filter2(c,fc)
	if not c:IsAbleToGraveAsCost() then return false end
	return c:IsCode(table.unpack(fc.material))
end
function c5412761.filter1(c,tp)
	return c.material and Duel.IsExistingMatchingCard(c5412761.filter2,tp,LOCATION_DECK,0,1,nil,c)
end
function c5412761.coscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c5412761.filter1,tp,LOCATION_EXTRA,0,1,nil,tp) end
end
function c5412761.cosoperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,c5412761.filter1,tp,LOCATION_EXTRA,0,1,1,nil,tp)
	Duel.ConfirmCards(1-tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local cg=Duel.SelectMatchingCard(tp,c5412761.filter2,tp,LOCATION_DECK,0,1,1,nil,g:GetFirst())
	if Duel.SendtoGrave(cg,REASON_COST)>0 then 
	local c=e:GetHandler()
	local tc=cg:GetFirst()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(tc:GetOriginalCode())
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(tc:GetOriginalRace())
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e3:SetValue(tc:GetOriginalAttribute())
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK_FINAL)
	e4:SetValue(tc:GetBaseAttack())
	e4:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e5:SetValue(tc:GetBaseDefense())
	e5:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CHANGE_LEVEL)
	e6:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e6:SetValue(tc:GetLevel())
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_ADD_TYPE)
	e7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e7:SetValue(tc:GetType())
	c:RegisterEffect(e7)
	c:CopyEffect(tc:GetCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(89312388,1))
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_PHASE+PHASE_END+RESET_PHASE+PHASE_END)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCountLimit(1)
	e8:SetRange(LOCATION_MZONE)
	e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e8:SetLabelObject(e1)
	e8:SetOperation(c5412761.rstop)
	c:RegisterEffect(e8)
end
end
function c5412761.rstop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=e:GetLabelObject()
	e1:Reset()
	Duel.HintSelection(Group.FromCards(c))
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end


