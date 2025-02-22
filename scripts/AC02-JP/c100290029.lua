--No.2 蚊学忍者シャドー・モスキート
--QQ：974559682 githubid:106670859
function c100290029.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,2,2,nil,nil,99)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	c:RegisterEffect(e2)
	--must attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_MUST_ATTACK)
	c:RegisterEffect(e3)
	--counter
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c100290029.target)
	e4:SetOperation(c100290029.ctop)
	c:RegisterEffect(e4)
end
c100290029.xyz_number=2
function c100290029.filter(c)
	return c:GetCounter(0x1161)>0 and c:IsFaceup()
end
function c100290029.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,nil,0x1161,1) and e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT)
	local b2=Duel.IsExistingMatchingCard(c100290029.filter,tp,0,LOCATION_MZONE,1,nil)
	if chk==0 then return b1 or b2 end
	local off=1
	local ops,opval={},{}
	if b1 then
		ops[off]=aux.Stringid(100290029,0)
		opval[off]=0
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(100290029,1)
		opval[off]=1
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))+1
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==0 then
		e:SetCategory(CATEGORY_COUNTER)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,1,1-tp,LOCATION_MZONE)
	elseif sel==1 then
		e:SetCategory(CATEGORY_DAMAGE)
		Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,nil)
	end
end
function c100290029.ctop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sel=e:GetLabel()
	if sel==0 then
		c:RemoveOverlayCard(tp,1,1,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		local g1=Duel.SelectMatchingCard(tp,Card.IsCanAddCounter,tp,0,LOCATION_MZONE,1,1,nil,0x1161,1)
		if #g1==0 then return end
		Duel.HintSelection(g1)
		local tc=g1:GetFirst()
		tc:AddCounter(0x1161,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
	elseif sel==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g2=Duel.SelectMatchingCard(tp,c100290029.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		if #g2==0 then return end
		Duel.HintSelection(g2)
		Duel.Damage(1-tp,g2:GetFirst():GetAttack(),REASON_EFFECT)
	end
end
