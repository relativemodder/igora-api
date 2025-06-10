from typing import Optional, List
from datetime import date, datetime
from pydantic import BaseModel, EmailStr, constr
from enum import Enum

class RoleBase(BaseModel):
    role_name: str
    role_description: Optional[str] = None
    permissions: Optional[dict] = None

class RoleCreate(RoleBase):
    pass

class Role(RoleBase):
    role_id: int

    class Config:
        orm_mode = True

class UserBase(BaseModel):
    login: str
    first_name: str
    last_name: str
    middle_name: Optional[str] = None
    role_id: int
    photo_path: Optional[str] = None
    is_active: Optional[bool] = True

class UserCreate(UserBase):
    password: str

class User(UserBase):
    user_id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        orm_mode = True

class ClientBase(BaseModel):
    client_code: constr(max_length=20)
    first_name: str
    last_name: str
    middle_name: Optional[str] = None
    email: Optional[EmailStr] = None
    phone: Optional[str] = None
    address: Optional[str] = None
    birth_date: Optional[date] = None
    passport_series: Optional[str] = None
    passport_number: Optional[str] = None

class ClientCreate(ClientBase):
    pass

class Client(ClientBase):
    client_id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        orm_mode = True

class EquipmentCategoryBase(BaseModel):
    category_name: str
    category_description: Optional[str] = None
    is_active: Optional[bool] = True

class EquipmentCategoryCreate(EquipmentCategoryBase):
    pass

class EquipmentCategory(EquipmentCategoryBase):
    category_id: int

    class Config:
        orm_mode = True

class EquipmentConditionStatus(str, Enum):
    excellent = "excellent"
    good = "good"
    satisfactory = "satisfactory"
    needs_repair = "needs_repair"

class EquipmentBase(BaseModel):
    category_id: int
    brand: Optional[str] = None
    model: Optional[str] = None
    size: Optional[str] = None
    condition_status: Optional[EquipmentConditionStatus] = EquipmentConditionStatus.excellent
    purchase_date: Optional[date] = None
    last_maintenance_date: Optional[date] = None
    is_available: Optional[bool] = True
    barcode: Optional[str] = None
    notes: Optional[str] = None

class EquipmentCreate(EquipmentBase):
    pass

class Equipment(EquipmentBase):
    equipment_id: int

    class Config:
        orm_mode = True

class ServiceBase(BaseModel):
    service_name: str
    service_description: Optional[str] = None
    category_id: Optional[int] = None
    hourly_rate: float
    daily_rate: Optional[float] = None
    deposit_amount: Optional[float] = None
    is_active: Optional[bool] = True

class ServiceCreate(ServiceBase):
    pass

class Service(ServiceBase):
    service_id: int
    created_at: Optional[datetime]
    updated_at: Optional[datetime]

    class Config:
        orm_mode = True

class OrderStatus(str, Enum):
    active = "active"
    completed = "completed"
    cancelled = "cancelled"
    archived = "archived"

class OrderBase(BaseModel):
    order_number: str
    client_id: int
    user_id: int
    start_date: datetime
    end_date: datetime
    total_amount: Optional[float] = 0
    deposit_amount: Optional[float] = None
    status: Optional[OrderStatus] = OrderStatus.active
    barcode: Optional[str] = None
    notes: Optional[str] = None

class OrderCreate(OrderBase):
    pass

class Order(OrderBase):
    order_id: int
    order_date: Optional[datetime]
    created_at: Optional[datetime]

    class Config:
        orm_mode = True

class OrderServiceBase(BaseModel):
    order_id: int
    service_id: int
    equipment_id: Optional[int] = None
    quantity: Optional[int] = 1
    unit_price: float
    total_price: float
    rental_hours: Optional[int] = None
    notes: Optional[str] = None

class OrderServiceCreate(OrderServiceBase):
    pass

class OrderService(OrderServiceBase):
    order_service_id: int

    class Config:
        orm_mode = True

class EquipmentReturnCondition(str, Enum):
    excellent = "excellent"
    good = "good"
    satisfactory = "satisfactory"
    damaged = "damaged"

class EquipmentReturnBase(BaseModel):
    order_id: int
    equipment_id: int
    returned_by_user_id: int
    condition_on_return: Optional[EquipmentReturnCondition] = EquipmentReturnCondition.good
    damage_description: Optional[str] = None
    additional_charges: Optional[float] = 0
    notes: Optional[str] = None

class EquipmentReturnCreate(EquipmentReturnBase):
    pass

class EquipmentReturn(EquipmentReturnBase):
    return_id: int
    return_date: Optional[datetime]

    class Config:
        orm_mode = True

class ConsumableBase(BaseModel):
    item_name: str
    item_description: Optional[str] = None
    unit_of_measure: Optional[str] = None
    current_stock: Optional[float] = 0
    minimum_stock: Optional[float] = 0
    unit_cost: Optional[float] = None
    supplier: Optional[str] = None
    is_active: Optional[bool] = True

class ConsumableCreate(ConsumableBase):
    pass

class Consumable(ConsumableBase):
    consumable_id: int
    last_updated: Optional[datetime]

    class Config:
        orm_mode = True

class ConsumableTransactionType(str, Enum):
    receipt = "receipt"
    consumption = "consumption"
    writeoff = "writeoff"

class ConsumableTransactionBase(BaseModel):
    consumable_id: int
    user_id: int
    transaction_type: ConsumableTransactionType
    quantity: float
    reason: Optional[str] = None
    document_number: Optional[str] = None
    notes: Optional[str] = None

class ConsumableTransactionCreate(ConsumableTransactionBase):
    pass

class ConsumableTransaction(ConsumableTransactionBase):
    transaction_id: int
    transaction_date: Optional[datetime]

    class Config:
        orm_mode = True
