#ifndef HUSRECTANGLE_H
#define HUSRECTANGLE_H

#include <QtQuick/QQuickPaintedItem>

#include "husglobal.h"
#include "husdefinitions.h"

QT_FORWARD_DECLARE_CLASS(HusRectanglePrivate)

class HUSKARUI_EXPORT HusRadius: public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusRadius)

    Q_PROPERTY(qreal all READ all WRITE setAll NOTIFY allChanged FINAL)
    Q_PROPERTY(qreal topLeft READ topLeft WRITE setTopLeft NOTIFY topLeftChanged FINAL)
    Q_PROPERTY(qreal topRight READ topRight WRITE setTopRight NOTIFY topRightChanged FINAL)
    Q_PROPERTY(qreal bottomLeft READ bottomLeft WRITE setBottomLeft NOTIFY bottomLeftChanged FINAL)
    Q_PROPERTY(qreal bottomRight READ bottomRight WRITE setBottomRight NOTIFY bottomRightChanged FINAL)

public:
    explicit HusRadius(QObject *parent = nullptr) : QObject{parent} { }

    [[nodiscard]] qreal all() const;
    void setAll(qreal all);

    [[nodiscard]] qreal topLeft() const;
    void setTopLeft(qreal topLeft);

    [[nodiscard]] qreal topRight() const;
    void setTopRight(qreal topRight);

    [[nodiscard]] qreal bottomLeft() const;
    void setBottomLeft(qreal bottomLeft);

    [[nodiscard]] qreal bottomRight() const;
    void setBottomRight(qreal bottomRight);

signals:
    void allChanged();
    void topLeftChanged();
    void topRightChanged();
    void bottomLeftChanged();
    void bottomRightChanged();

private:
    qreal m_all = 0.;
    qreal m_topLeft = -1.;
    qreal m_topRight = -1.;
    qreal m_bottomLeft = -1.;
    qreal m_bottomRight = -1.;
};

class HUSKARUI_EXPORT HusPen: public QObject
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusPen)

    HUS_PROPERTY_INIT(qreal, width, setWidth, 1)
    HUS_PROPERTY_INIT(QColor, color, setColor, Qt::transparent)
    HUS_PROPERTY_INIT(int, style, setStyle, Qt::SolidLine)

public:
    explicit HusPen(QObject *parent = nullptr) : QObject{parent} { }

    [[nodiscard]] bool isValid() const {
        return m_width > 0 && m_color.isValid() && m_color.alpha() > 0;
    }
};

class HUSKARUI_EXPORT HusRectangle: public QQuickPaintedItem
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusRectangle)

    Q_PROPERTY(QColor color READ color WRITE setColor NOTIFY colorChanged FINAL)
    Q_PROPERTY(QJSValue gradient READ gradient WRITE setGradient RESET resetGradient)
    Q_PROPERTY(HusPen* border READ border CONSTANT)

    Q_PROPERTY(qreal radius READ radius WRITE setRadius NOTIFY radiusChanged FINAL)
    Q_PROPERTY(qreal topLeftRadius READ topLeftRadius WRITE setTopLeftRadius NOTIFY topLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal topRightRadius READ topRightRadius WRITE setTopRightRadius NOTIFY topRightRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomLeftRadius READ bottomLeftRadius WRITE setBottomLeftRadius NOTIFY bottomLeftRadiusChanged FINAL)
    Q_PROPERTY(qreal bottomRightRadius READ bottomRightRadius WRITE setBottomRightRadius NOTIFY bottomRightRadiusChanged FINAL)

public:
    explicit HusRectangle(QQuickItem *parent = nullptr);

    [[nodiscard]] QColor color() const;
    void setColor(QColor color);

    HusPen *border();

    [[nodiscard]] QJSValue gradient() const;
    void setGradient(const QJSValue &gradient);
    void resetGradient();

    [[nodiscard]] qreal radius() const;
    void setRadius(qreal radius);

    [[nodiscard]] qreal topLeftRadius() const;
    void setTopLeftRadius(qreal radius);

    [[nodiscard]] qreal topRightRadius() const;
    void setTopRightRadius(qreal radius);

    [[nodiscard]] qreal bottomLeftRadius() const;
    void setBottomLeftRadius(qreal radius);

    [[nodiscard]] qreal bottomRightRadius() const;
    void setBottomRightRadius(qreal radius);

signals:
    void colorChanged();
    void radiusChanged();
    void topLeftRadiusChanged();
    void topRightRadiusChanged();
    void bottomLeftRadiusChanged();
    void bottomRightRadiusChanged();

protected:
    void paint(QPainter *painter) override;

private Q_SLOTS:
    void doUpdate();

private:
    Q_DECLARE_PRIVATE(HusRectangle);
    QSharedPointer<HusRectanglePrivate> d_ptr;
};

#if QT_VERSION >= QT_VERSION_CHECK(6, 7, 0)
# include <private/qquickrectangle_p.h>

/*! 内部矩形, 作为高版本基础控件时在内部使用, 但无法使用 border.style */
class HusRectangleInternal: public QQuickRectangle
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusRectangleInternal)

public:
    explicit HusRectangleInternal(QQuickItem *parent = nullptr) : QQuickRectangle{parent} { }
};

#else

class HusRectangleInternal: public HusRectangle
{
    Q_OBJECT
    QML_NAMED_ELEMENT(HusRectangleInternal)

public:
    explicit HusRectangleInternal(QQuickItem *parent = nullptr) : HusRectangle{parent} { }
    ~HusRectangleInternal() { };
};

#endif

#endif // HUSRECTANGLE_H
