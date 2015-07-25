#pragma once

#include "style.h"
#include "glm/vec2.hpp"
#include "glm/vec3.hpp"
#include "gl/typedMesh.h"
#include "labels/labels.h"
#include "labels/spriteAtlas.h"

namespace Tangram {

class Texture;

class SpriteStyle : public Style {

protected:

    virtual void constructVertexLayout() override;
    virtual void constructShaderProgram() override;
    virtual void buildPoint(Point& _point, const StyleParamMap& _styleParamMap, Properties& _props, VboMesh& _mesh, Tile& _tile) const override;

    /*
     * Creates a sprite slabel for and associate it with the current processed <MapTile> TileID for a specific syle name
     * Returns the created labe
     */
    std::shared_ptr<Label> addSpriteLabel(Tile& _tile, Label::Transform _transform, const glm::vec2& _size, size_t _bufferOffset) const;

    typedef TypedMesh<BufferVert> Mesh;

    virtual VboMesh* newMesh() const override {
        return new Mesh(m_vertexLayout, m_drawMode, GL_DYNAMIC_DRAW);
    };

    std::unique_ptr<SpriteAtlas> m_spriteAtlas;
    std::shared_ptr<Labels> m_labels;
    size_t m_stateAttribOffset;

public:

    bool isOpaque() const override { return false; }

    virtual void onBeginDrawFrame(const std::shared_ptr<View>& _view, const std::shared_ptr<Scene>& _scene) override;

    SpriteStyle(std::string _name, GLenum _drawMode = GL_TRIANGLES);

    virtual ~SpriteStyle();

};

}
