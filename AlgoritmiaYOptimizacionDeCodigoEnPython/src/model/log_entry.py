from datetime import datetime

from pydantic import BaseModel


#@dataclass
class LogEntry(BaseModel):
    timestamp: datetime
    tag: str  # e.g., "INFO", "ERROR", "DEBUG"
    message: str
    
    def __lt__(self, other: 'LogEntry'):
        """Compara dos objetos LogEntry basándose en sus timestamps.
    
        Este método mágico permite realizar operaciones de comparación entre logs,
        lo cual es necesario para:
        1. Ordenar logs cronológicamente
        2. Encontrar el log más antiguo/reciente usando min()/max()
        3. Mantener el orden temporal en colecciones de logs
        
        Ejemplo:
            log1 = LogEntry(timestamp=datetime.now(), tag="INFO", message="Primer log")
            log2 = LogEntry(timestamp=datetime.now(), tag="ERROR", message="Segundo log")
            log_mas_antiguo = min(log1, log2)  # Retorna el log con timestamp más antiguo
        
        Args:
            other (LogEntry): Otro objeto LogEntry con el cual comparar
        
        Returns:
            bool: True si el timestamp de este log es más antiguo que el otro
        
        Raises:
            TypeError: Si se intenta comparar con un objeto que no es LogEntry
        
        Note:
            Este método es fundamental para el funcionamiento del cache temporal
            y el proceso de limpieza (pruning) de logs antiguos.
        """
        assert isinstance(other, LogEntry), NotImplemented
        return self.timestamp < other.timestamp
    
    class Config:
        frozen = True