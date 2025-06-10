from sqlalchemy import (
    Column, Integer, String, Text, Boolean, Date, DateTime, Enum, ForeignKey, DECIMAL, JSON
)
from sqlalchemy.orm import relationship, declarative_base
import enum

Base = declarative_base()

class Role(Base):
    __tablename__ = "Roles"
    role_id = Column(Integer, primary_key=True, index=True)
    role_name = Column(String(50), unique=True, nullable=False)
    role_description = Column(Text)
    permissions = Column(JSON)

    users = relationship("User", back_populates="role")

class User(Base):
    __tablename__ = "Users"
    user_id = Column(Integer, primary_key=True, index=True)
    login = Column(String(50), unique=True, nullable=False)
    password_hash = Column(String(255), nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    middle_name = Column(String(100))
    role_id = Column(Integer, ForeignKey("Roles.role_id"), nullable=False)
    photo_path = Column(String(500))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    role = relationship("Role", back_populates="users")

class Client(Base):
    __tablename__ = "Clients"
    client_id = Column(Integer, primary_key=True, index=True)
    client_code = Column(String(20), unique=True, nullable=False)
    first_name = Column(String(100), nullable=False)
    last_name = Column(String(100), nullable=False)
    middle_name = Column(String(100))
    email = Column(String(255), unique=True)
    phone = Column(String(20))
    address = Column(Text)
    birth_date = Column(Date)
    passport_series = Column(String(10))
    passport_number = Column(String(20))
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

class EquipmentCategory(Base):
    __tablename__ = "Equipment_Categories"
    category_id = Column(Integer, primary_key=True, index=True)
    category_name = Column(String(100), nullable=False)
    category_description = Column(Text)
    is_active = Column(Boolean, default=True)

    equipment = relationship("Equipment", back_populates="category")
    services = relationship("Service", back_populates="category")

class EquipmentConditionStatus(enum.Enum):
    excellent = "excellent"
    good = "good"
    satisfactory = "satisfactory"
    needs_repair = "needs_repair"

class Equipment(Base):
    __tablename__ = "Equipment"
    equipment_id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, ForeignKey("Equipment_Categories.category_id"), nullable=False)
    brand = Column(String(100))
    model = Column(String(100))
    size = Column(String(20))
    condition_status = Column(Enum(EquipmentConditionStatus), default=EquipmentConditionStatus.excellent)
    purchase_date = Column(Date)
    last_maintenance_date = Column(Date)
    is_available = Column(Boolean, default=True)
    barcode = Column(String(255), unique=True)
    notes = Column(Text)

    category = relationship("EquipmentCategory", back_populates="equipment")

class Service(Base):
    __tablename__ = "Services"
    service_id = Column(Integer, primary_key=True, index=True)
    service_name = Column(String(200), nullable=False)
    service_description = Column(Text)
    category_id = Column(Integer, ForeignKey("Equipment_Categories.category_id"))
    hourly_rate = Column(DECIMAL(10, 2), nullable=False)
    daily_rate = Column(DECIMAL(10, 2))
    deposit_amount = Column(DECIMAL(10, 2))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime)
    updated_at = Column(DateTime)

    category = relationship("EquipmentCategory", back_populates="services")

class OrderStatus(enum.Enum):
    active = "active"
    completed = "completed"
    cancelled = "cancelled"
    archived = "archived"

class Order(Base):
    __tablename__ = "Orders"
    order_id = Column(Integer, primary_key=True, index=True)
    order_number = Column(String(50), unique=True, nullable=False)
    client_id = Column(Integer, ForeignKey("Clients.client_id"), nullable=False)
    user_id = Column(Integer, ForeignKey("Users.user_id"), nullable=False)
    order_date = Column(DateTime)
    start_date = Column(DateTime, nullable=False)
    end_date = Column(DateTime, nullable=False)
    total_amount = Column(DECIMAL(12, 2), default=0)
    deposit_amount = Column(DECIMAL(10, 2))
    status = Column(Enum(OrderStatus), default=OrderStatus.active)
    barcode = Column(String(255), unique=True)
    notes = Column(Text)
    created_at = Column(DateTime)

    client = relationship("Client")
    user = relationship("User")

class OrderService(Base):
    __tablename__ = "Order_Services"
    order_service_id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("Orders.order_id", ondelete="CASCADE"), nullable=False)
    service_id = Column(Integer, ForeignKey("Services.service_id"), nullable=False)
    equipment_id = Column(Integer, ForeignKey("Equipment.equipment_id"))
    quantity = Column(Integer, default=1)
    unit_price = Column(DECIMAL(10, 2), nullable=False)
    total_price = Column(DECIMAL(10, 2), nullable=False)
    rental_hours = Column(Integer)
    notes = Column(Text)

    order = relationship("Order")
    service = relationship("Service")
    equipment = relationship("Equipment")

class EquipmentReturnCondition(enum.Enum):
    excellent = "excellent"
    good = "good"
    satisfactory = "satisfactory"
    damaged = "damaged"

class EquipmentReturn(Base):
    __tablename__ = "Equipment_Returns"
    return_id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("Orders.order_id"), nullable=False)
    equipment_id = Column(Integer, ForeignKey("Equipment.equipment_id"), nullable=False)
    returned_by_user_id = Column(Integer, ForeignKey("Users.user_id"), nullable=False)
    return_date = Column(DateTime)
    condition_on_return = Column(Enum(EquipmentReturnCondition), default=EquipmentReturnCondition.good)
    damage_description = Column(Text)
    additional_charges = Column(DECIMAL(10, 2), default=0)
    notes = Column(Text)

    order = relationship("Order")
    equipment = relationship("Equipment")
    returned_by_user = relationship("User")

class ConsumableTransactionType(enum.Enum):
    receipt = "receipt"
    consumption = "consumption"
    writeoff = "writeoff"

class Consumable(Base):
    __tablename__ = "Consumables"
    consumable_id = Column(Integer, primary_key=True, index=True)
    item_name = Column(String(200), nullable=False)
    item_description = Column(Text)
    unit_of_measure = Column(String(20))
    current_stock = Column(DECIMAL(10, 2), default=0)
    minimum_stock = Column(DECIMAL(10, 2), default=0)
    unit_cost = Column(DECIMAL(10, 2))
    supplier = Column(String(200))
    last_updated = Column(DateTime)
    is_active = Column(Boolean, default=True)

class ConsumableTransaction(Base):
    __tablename__ = "Consumable_Transactions"
    transaction_id = Column(Integer, primary_key=True, index=True)
    consumable_id = Column(Integer, ForeignKey("Consumables.consumable_id"), nullable=False)
    user_id = Column(Integer, ForeignKey("Users.user_id"), nullable=False)
    transaction_type = Column(Enum(ConsumableTransactionType), nullable=False)
    quantity = Column(DECIMAL(10, 2), nullable=False)
    transaction_date = Column(DateTime)
    reason = Column(Text)
    document_number = Column(String(100))
    notes = Column(Text)

    consumable = relationship("Consumable")
    user = relationship("User")
